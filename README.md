# PowerKilo
<!--
<a href="http://kolejopedia.pl" target="_blank" rel="noopener noreferrer" style="display: inline-block; text-decoration: none; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; font-weight: bold; font-size: 22px; cursor: pointer; border-radius: 14px; padding: 4px; background: linear-gradient(to bottom, #4a4a4a, #282828); box-shadow: 0 8px 16px rgba(0, 0, 0, 0.6), inset 0 2px 3px rgba(255, 255, 255, 0.2); user-select: none;">
  <span style="display: flex; align-items: center; gap: 14px; padding: 16px 36px; border-radius: 10px; color: #ffffff; text-shadow: 0 -1px 2px rgba(0, 0, 0, 0.8), 0 1px 1px rgba(255, 255, 255, 0.3); background: linear-gradient(to bottom, #34a853 0%, #25783b 50%, #1b5e2b 100%); box-shadow: inset 0 4px 5px rgba(255, 255, 255, 0.4), inset 0 -4px 6px rgba(0, 0, 0, 0.6), 0 2px 0px rgba(0, 0, 0, 0.5);">
    <span style="font-size: 26px; background: #113c1b; color: #a3e2b4; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; border-radius: 50%; box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.8), 0 1px 1px rgba(255, 255, 255, 0.2);">⬇</span>
    <span>Pobierz</span>
  </span>
</a>

<a href="http://kolejopedia.pl" class="skeuomorphic-download-btn" target="_blank" rel="noopener noreferrer">
  <span class="btn-inner">
    <span class="btn-icon">⬇</span>
    <span class="btn-text">Pobierz</span>
  </span>
</a>

<style>
  /* Stylizacja bazy przycisku - kontener zewnętrzny tworzący głęboki, fizyczny cień */
  .skeuomorphic-download-btn {
    display: inline-block;
    text-decoration: none;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    font-weight: bold;
    font-size: 22px;
    cursor: pointer;
    border-radius: 14px;
    padding: 4px; /* Przestrzeń na 'ramkę' obudowy */
    background: linear-gradient(to bottom, #4a4a4a, #282828);
    box-shadow: 
      0 8px 16px rgba(0, 0, 0, 0.6),      /* Główny cień rzucany przez przycisk */
      inset 0 2px 3px rgba(255, 255, 255, 0.2); /* Delikatny połysk na krawędzi */
    transition: transform 0.1s ease, box-shadow 0.1s ease;
    user-select: none;
  }

  /* Wnętrze przycisku - właściwy trójwymiarowy plastikowy klawisz */
  .skeuomorphic-download-btn .btn-inner {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 16px 36px;
    border-radius: 10px;
    color: #ffffff;
    text-shadow: 0 -1px 2px rgba(0, 0, 0, 0.8), 0 1px 1px rgba(255, 255, 255, 0.3);
    
    /* Głębia skeumorficzna: mocny gradient i podwójne fasetowanie */
    background: linear-gradient(to bottom, #34a853 0%, #25783b 50%, #1b5e2b 100%);
    box-shadow: 
      inset 0 4px 5px rgba(255, 255, 255, 0.4),  /* Górne mocne światło odbite */
      inset 0 -4px 6px rgba(0, 0, 0, 0.6),       /* Dolny cień własny */
      0 2px 0px rgba(0, 0, 0, 0.5);              /* Odcięcie klawisza od obudowy */
    
    transition: background 0.2s ease;
  }

  /* Ikona strzałki z efektem wgłębienia (wklęsłości) */
  .skeuomorphic-download-btn .btn-icon {
    font-size: 26px;
    background: #113c1b;
    color: #a3e2b4;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    box-shadow: 
      inset 0 2px 4px rgba(0, 0, 0, 0.8), 
      0 1px 1px rgba(255, 255, 255, 0.2);
  }

  /* Efekt po najechaniu (Hover) - przycisk zaczyna delikatnie "żarzyć" */
  .skeuomorphic-download-btn:hover .btn-inner {
    background: linear-gradient(to bottom, #3cb85d 0%, #2b8743 50%, #1f6b32 100%);
    color: #f0f0f0;
  }

  .skeuomorphic-download-btn:hover {
    box-shadow: 
      0 10px 20px rgba(0, 0, 0, 0.7), 
      0 0 12px rgba(52, 168, 83, 0.4), /* Zielona poświata wokół */
      inset 0 2px 3px rgba(255, 255, 255, 0.3);
  }

  /* Efekt kliknięcia (Active) - fizyczne wciśnięcie klawisza do obudowy */
  .skeuomorphic-download-btn:active {
    transform: translateY(4px); /* Przycisk idzie w dół */
    box-shadow: 
      0 2px 4px rgba(0, 0, 0, 0.8), /* Cień drastycznie maleje */
      inset 0 1px 2px rgba(0, 0, 0, 0.5);
  }

  .skeuomorphic-download-btn:active .btn-inner {
    /* Odwrócenie gradientu i cieni, aby zasymulować wklęsłość przy nacisku */
    background: linear-gradient(to bottom, #1b5e2b 0%, #25783b 100%);
    box-shadow: 
      inset 0 4px 6px rgba(0, 0, 0, 0.8), 
      inset 0 -2px 3px rgba(255, 255, 255, 0.2);
  }
</style>
-->
<a href="https://github.com/alankingpl0-oss/PowerKilo/releases">
  <img src="https://img.shields.io/badge/Pobierz-PowerKilo--blue?style=plastic&icon=github" width="200" alt="Pobierz">
</a>

## Uwaga!
### Zobacz dodatkowe oficjalne wtyczki tutaj: 
<a href="https://github.com/alankingpl0-oss/powerkilo-wtyczki">
  <img src="https://img.shields.io/badge/Wtyczki-PowerKilo--blue?style=plastic&icon=github" width="200" alt="Pobierz">
</a>

---

<!--
[![Pobierz](https://img.shields.io/badge/Pobierz-PowerKilo--blue?style=plastic&icon=github)](https://github.com/alankingpl0-oss/PowerKilo/releases)
-->
Bardzo dobry edytor tekstu.
Edytor w C, ale wtyczki w Fortranie.
