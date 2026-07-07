#include <gtk/gtk.h>

typedef struct {
    GtkWidget *text_view;
    GtkWidget *status_bar;
    void (*set_status_func)(const char*);
} PowerKiloAPI;

char* plugin_name() {
    return "Super Formatowanie";
}

char* plugin_help() {
    return "Ta wtyczka czyści tekst i ustawia własny status.";
}

void run_plugin(PowerKiloAPI *api) {
    /* Wtyczka wyciąga bufor bezpośrednio z programu-matki */
    GtkTextBuffer *buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(api->text_view));
    
    /* Może wstawić dowolny tekst */
    gtk_text_buffer_set_text(buffer, "Tekst podmieniony bezpośrednio przez API wtyczki!", -1);
    
    /* Może użyć naszej wewnętrznej funkcji statusu */
    api->set_status_func("Wtyczka zamieszała w strukturach!");
}