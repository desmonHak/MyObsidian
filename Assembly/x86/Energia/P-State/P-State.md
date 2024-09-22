vea [[G-State]], [[S-State]], [[C-States]], [[P-State]], [[M-State]], [[D-State]]
![[Pasted image 20240916231012.png]]Los **estados P, [[P-States]] o Performance State** son otros de los más importantes de cara a la ``CPU``. Estos estados de consumo son los que los diseñadores de procesadores patentan bajo marcas registradas como Intel [[SpeedStep]], AMD [[Power_Now]]!, etc. Y los estados de rendimiento son:
- **[[P0]]**: máximo voltaje y frecuencia.
- **[[P1]]**: se escala la frecuencia y voltaje a valores ligeramente por debajo de P0.
- **[[P2]]**: menor frecuencia y voltaje que P1.
- **Pn**: menos…

Como se aprecia en la anterior imagen, los estados están relacionados entre sí como comenté anteriormente. Los G pueden llevar a estados S concretos, y estos a su vez a otros.

Todo esto estará controlado por el propio **sistema operativo**, los controladores, el firmware y [[ACPI]], que le darán al hardware lo que necesita. Por ejemplo, el sistema operativo, a través de los gobernadores puede indicarle al controlador de la ``CPU`` que baje su frecuencia a 500 Mhz cuando estás usando un software de ofimática, que no necesita de gran rendimiento. De este modo se ahorra energía y se reduce la temperatura. En cambio, cuando se demanda más rendimiento, como en un videojuego, el gobernador del sistema operativo hará justo lo contrario, podrá elevar la frecuencia a la máxima posible para que la ``CPU`` rinda como se espera.