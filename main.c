#include <gtk/gtk.h>
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>

typedef char* (*PluginFunc)(const char*);
typedef char* (*InfoFunc)();

GtkWidget *text_view;
GtkWidget *status_bar;
guint status_context_id;

void set_status(const char *message) {
    gtk_statusbar_pop(GTK_STATUSBAR(status_bar), status_context_id);
    gtk_statusbar_push(GTK_STATUSBAR(status_bar), status_context_id, message);
}

// --- FUNKCJE PLIKÓW ---

// --- NOWA FUNKCJA: Odczyt danych z dysku ---
void open_file(const char *filename) {
    char *contents;
    gsize length;
    GError *error = NULL;

    // Glib wczytuje cały plik do bufora 'contents'
    if (g_file_get_contents(filename, &contents, &length, &error)) {
        GtkTextBuffer *buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(text_view));
        gtk_text_buffer_set_text(buffer, contents, length);
        g_free(contents);
        
        char msg[256];
        snprintf(msg, sizeof(msg), "Otwarto: %s", filename);
        set_status(msg);
    } else {
        set_status("Błąd otwierania pliku!");
        if (error) g_error_free(error);
    }
}

// --- NOWA FUNKCJA: Obsługa kliknięcia "Otwórz" ---
void on_open_clicked(GtkWidget *widget, gpointer data) {
    GtkWidget *parent_window = gtk_widget_get_toplevel(widget);
    GtkWidget *dialog = gtk_file_chooser_dialog_new("Otwórz plik",
                                      GTK_WINDOW(parent_window),
                                      GTK_FILE_CHOOSER_ACTION_OPEN,
                                      "_Anuluj", GTK_RESPONSE_CANCEL,
                                      "_Otwórz", GTK_RESPONSE_ACCEPT,
                                      NULL);

    if (gtk_dialog_run(GTK_DIALOG(dialog)) == GTK_RESPONSE_ACCEPT) {
        char *filename = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(dialog));
        open_file(filename);
        g_free(filename);
    }
    gtk_widget_destroy(dialog);
}


void save_to_file(const char *filename) {
    GtkTextBuffer *buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(text_view));
    GtkTextIter start, end;
    gtk_text_buffer_get_bounds(buffer, &start, &end);
    char *contents = gtk_text_buffer_get_text(buffer, &start, &end, FALSE);

    FILE *f = fopen(filename, "w");
    if (f) {
        fputs(contents, f);
        fclose(f);
        char msg[256];
        snprintf(msg, sizeof(msg), "Zapisano: %s", filename);
        set_status(msg);
    } else {
        set_status("Błąd zapisu pliku!");
    }
    g_free(contents);
}

void on_save_clicked(GtkWidget *widget, gpointer data) {
    GtkWidget *parent_window = gtk_widget_get_toplevel(widget);
    GtkWidget *dialog = gtk_file_chooser_dialog_new("Zapisz plik",
                                      GTK_WINDOW(parent_window),
                                      GTK_FILE_CHOOSER_ACTION_SAVE,
                                      "_Anuluj", GTK_RESPONSE_CANCEL,
                                      "_Zapisz", GTK_RESPONSE_ACCEPT,
                                      NULL);

    gtk_file_chooser_set_do_overwrite_confirmation(GTK_FILE_CHOOSER(dialog), TRUE);

    if (gtk_dialog_run(GTK_DIALOG(dialog)) == GTK_RESPONSE_ACCEPT) {
        char *filename = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(dialog));
        save_to_file(filename);
        g_free(filename);
    }

    gtk_widget_destroy(dialog);
}

// --- OKNO INSTRUKCJI ---
void show_plugin_help(GtkWidget *widget, gpointer data) {
    void *handle = data;
    InfoFunc get_help = dlsym(handle, "plugin_help");
    
    GtkWidget *parent = gtk_widget_get_toplevel(widget);
    if (get_help) {
        GtkWidget *dialog = gtk_message_dialog_new(GTK_WINDOW(parent),
                                 GTK_DIALOG_MODAL,
                                 GTK_MESSAGE_INFO,
                                 GTK_BUTTONS_OK,
                                 "%s", get_help());
        gtk_window_set_title(GTK_WINDOW(dialog), "Instrukcja wtyczki");
        gtk_dialog_run(GTK_DIALOG(dialog));
        gtk_widget_destroy(dialog);
    } else {
        set_status("Ta wtyczka nie posiada instrukcji.");
    }
}

// --- WYKONYWANIE WTYCZKI ---
void execute_plugin(GtkWidget *widget, gpointer data) {
    void *handle = data;
    PluginFunc run_plugin = dlsym(handle, "run_plugin");
    
    if (!run_plugin) {
        set_status("Błąd: Brak funkcji run_plugin");
        return;
    }

    GtkTextBuffer *buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(text_view));
    GtkTextIter start, end;
    gtk_text_buffer_get_bounds(buffer, &start, &end);
    char *input_text = gtk_text_buffer_get_text(buffer, &start, &end, FALSE);

    char *result = run_plugin(input_text);
    if (result) {
        gtk_text_buffer_set_text(buffer, result, -1);
        set_status("Wtyczka zakończyła pracę.");
    }
    g_free(input_text);
}

// --- ŁADOWANIE WTYCZEK ---
void load_plugins(GtkWidget *plugin_menu) {
    DIR *dir;
    struct dirent *ent;
    if ((dir = opendir("./plugins")) != NULL) {
        while ((ent = readdir(dir)) != NULL) {
            if (strstr(ent->d_name, ".so")) {
                char path[512];
                snprintf(path, sizeof(path), "./plugins/%s", ent->d_name);

                void *handle = dlopen(path, RTLD_LAZY);
                if (!handle) continue;

                InfoFunc get_name = dlsym(handle, "plugin_name");
                if (get_name) {
                    GtkWidget *plugin_root_item = gtk_menu_item_new_with_label(get_name());
                    GtkWidget *sub_menu = gtk_menu_new();
                    gtk_menu_item_set_submenu(GTK_MENU_ITEM(plugin_root_item), sub_menu);

                    GtkWidget *run_item = gtk_menu_item_new_with_label("Uruchom");
                    g_signal_connect(run_item, "activate", G_CALLBACK(execute_plugin), handle);
                    gtk_menu_shell_append(GTK_MENU_SHELL(sub_menu), run_item);

                    GtkWidget *help_item = gtk_menu_item_new_with_label("Instrukcja");
                    g_signal_connect(help_item, "activate", G_CALLBACK(show_plugin_help), handle);
                    gtk_menu_shell_append(GTK_MENU_SHELL(sub_menu), help_item);

                    gtk_menu_shell_append(GTK_MENU_SHELL(plugin_menu), plugin_root_item);
                    gtk_widget_show_all(plugin_root_item);
                }
            }
        }
        closedir(dir);
    }
}

int main(int argc, char *argv[]) {
    gtk_init(&argc, &argv);

    // 1. Główne okno
    GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "C-Binary Editor");
    gtk_window_set_default_size(GTK_WINDOW(window), 800, 600);
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    GtkWidget *vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0);
    gtk_container_add(GTK_CONTAINER(window), vbox);

    // 2. Pasek menu
    GtkWidget *menu_bar = gtk_menu_bar_new();
    gtk_box_pack_start(GTK_BOX(vbox), menu_bar, FALSE, FALSE, 0);

    // 3. Menu PLIK (Tworzenie struktury)
    GtkWidget *file_item = gtk_menu_item_new_with_label("Plik");
    GtkWidget *file_menu = gtk_menu_new();
    gtk_menu_item_set_submenu(GTK_MENU_ITEM(file_item), file_menu);
    gtk_menu_shell_append(GTK_MENU_SHELL(menu_bar), file_item);

    // 4. Elementy menu PLIK
    GtkWidget *open_item = gtk_menu_item_new_with_label("Otwórz");
    GtkWidget *save_item = gtk_menu_item_new_with_label("Zapisz");
    GtkWidget *exit_item = gtk_menu_item_new_with_label("Wyjście");

    gtk_menu_shell_append(GTK_MENU_SHELL(file_menu), open_item);
    gtk_menu_shell_append(GTK_MENU_SHELL(file_menu), save_item);
    gtk_menu_shell_append(GTK_MENU_SHELL(file_menu), gtk_separator_menu_item_new());
    gtk_menu_shell_append(GTK_MENU_SHELL(file_menu), exit_item);

    // 5. Menu WTYCZKI
    GtkWidget *plugin_item = gtk_menu_item_new_with_label("Wtyczki");
    GtkWidget *plugin_menu = gtk_menu_new();
    gtk_menu_item_set_submenu(GTK_MENU_ITEM(plugin_item), plugin_menu);
    gtk_menu_shell_append(GTK_MENU_SHELL(menu_bar), plugin_item);

    // 6. Obszar tekstowy (Scrolled Window)
    text_view = gtk_text_view_new();
    gtk_text_view_set_left_margin(GTK_TEXT_VIEW(text_view), 5);
    GtkWidget *scroll = gtk_scrolled_window_new(NULL, NULL);
    gtk_container_add(GTK_CONTAINER(scroll), text_view);
    gtk_box_pack_start(GTK_BOX(vbox), scroll, TRUE, TRUE, 0);

    // 7. Pasek statusu
    status_bar = gtk_statusbar_new();
    status_context_id = gtk_statusbar_get_context_id(GTK_STATUSBAR(status_bar), "status");
    gtk_box_pack_start(GTK_BOX(vbox), status_bar, FALSE, FALSE, 0);
    set_status("Gotowy");

    // 8. Sygnały (Akcje)
    g_signal_connect(open_item, "activate", G_CALLBACK(on_open_clicked), NULL);
    g_signal_connect(save_item, "activate", G_CALLBACK(on_save_clicked), NULL);
    g_signal_connect(exit_item, "activate", G_CALLBACK(gtk_main_quit), NULL);

    // 9. Ładowanie wtyczek z folderu
    load_plugins(plugin_menu);

    // 10. Start
    gtk_widget_show_all(window);
    gtk_main();

    return 0;
}