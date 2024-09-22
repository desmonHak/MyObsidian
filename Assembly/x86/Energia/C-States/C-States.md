https://foro.geeknetic.es/hardware/procesadores/20162-diferencia-entre-los-c-states
Los C-States son conocidos ya desde hace mucho tiempo, han ido evolucionando pero siempre han tenido un objetivo claro, ahorrar energía.  
  
Enfocados a los procesadores, los [[C-States]] están pensados para disminuir el consumo de los procesadores cuando están en carga baja o en idle. Desde los Pentium en sus primeras generaciones ya se vienen viendo estas aplicaciones, no tan avanzadas como lo están ahora pero sí cumplían su función como buenamente podían. Existen distintos tipos de [[C-States]], cada uno destinado a una remesa de procesadores o plataformas en concreto, pero se puede llegar a categorizar en los siguientes: [[C0]], [[C1]], [[C1E]], [[C2]], [[C2E]], [[C3]], [[C4]], [[C5]], [[C6]] y [[C7]]. Cuanto más alto sea el número que acompaña a la”C”, más profundo será el estado de ahorro de energía del procesador.
![[Pasted image 20240916225402.png]]

- **[[C0]]**: operativo.
- **[[C1]]/[[C1E]]**: halt, el procesador no está procesando instrucciones, pero puede regresar a un estado de ejecución de forma instantánea. Los modernos procesadores tienen [[C1E]] (Enhanced Halt State) para reducir aún más el consumo.
- **[[C2]]**: Stop-clock, mantiene el estado de forma similar al C1, pero puede tardar más en regresar a su estado activo al haber detenido el reloj.
- **[[C3]]**: existen variantes como Sleep, Deep Sleep o Deeper Sleep. Un estado en el que la cache L1 y L2 se vacían en la LLC, y todos los relojes centrales se apagan. Solo se mantiene el núcleo encendido para mantener su estado.
- **[[C4]]-[[C10]]:** otros procesadores han integrado más estados para ahorros mayores. Por ejemplo, el [[C6]] apagará el núcleo también y guarda el estado en una SRAM dedicada para que el voltaje del core sea 0v. Cuando se sale de [[C6]] se puede restablecer el estado desde la SRAM.