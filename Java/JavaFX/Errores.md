
El error se produce porque JavaFX utiliza reflexión para acceder a las propiedades de la clase **Product**, y el sistema de módulos de Java (introducido en Java 9) impide ese acceso a menos que se "abra" el paquete correspondiente. En tu caso, el módulo **javafx.base** no puede acceder a la clase **com.example.tablasfx.models.Product** porque el módulo **com.example.tablasfx** no ha abierto ese paquete para la reflexión.

Para solucionarlo, debes modificar tu archivo **module-info.java** para abrir el paquete **com.example.tablasfx.models** a los módulos necesarios (por ejemplo, a **javafx.fxml** y **javafx.base**). Una forma de hacerlo es agregando la siguiente línea en tu **module-info.java**:
```java
	at javafx.base/javafx.beans.property.BooleanPropertyBase.set(BooleanPropertyBase.java:145)
	at javafx.graphics/javafx.stage.Window.setShowing(Window.java:1211)
	at javafx.graphics/javafx.stage.Window.show(Window.java:1226)
	at javafx.graphics/javafx.stage.Stage.show(Stage.java:277)
	at com.example.tablasfx/com.example.tablasfx.HelloApplication.start(HelloApplication.java:27)
	at javafx.graphics/com.sun.javafx.application.LauncherImpl.lambda$launchApplication1$9(LauncherImpl.java:847)
	at javafx.graphics/com.sun.javafx.application.PlatformImpl.lambda$runAndWait$12(PlatformImpl.java:484)
	at javafx.graphics/com.sun.javafx.application.PlatformImpl.lambda$runLater$10(PlatformImpl.java:457)
	at java.base/java.security.AccessController.doPrivileged(AccessController.java:400)
	at javafx.graphics/com.sun.javafx.application.PlatformImpl.lambda$runLater$11(PlatformImpl.java:456)
	at javafx.graphics/com.sun.glass.ui.InvokeLaterDispatcher$Future.run(InvokeLaterDispatcher.java:96)
	at javafx.graphics/com.sun.glass.ui.win.WinApplication._runLoop(Native Method)
	at javafx.graphics/com.sun.glass.ui.win.WinApplication.lambda$runLoop$3(WinApplication.java:184)
	at java.base/java.lang.Thread.run(Thread.java:1575)
Caused by: java.lang.IllegalAccessException: module javafx.base cannot access class com.example.tablasfx.models.Product (in module com.example.tablasfx) because module com.example.tablasfx does not open com.example.tablasfx.models to javafx.base
	at javafx.base/com.sun.javafx.property.MethodHelper.invoke(MethodHelper.java:70)
	at javafx.base/com.sun.javafx.property.PropertyReference.get(PropertyReference.java:171)
	... 68 more
```
Cuando pasa este error:
```java
Caused by: java.lang.IllegalAccessException: module javafx.base cannot access class com.example.tablasfx.models.Product (in module com.example.tablasfx) because module com.example.tablasfx does not open com.example.tablasfx.models to javafx.base
```
Es necesario agregar el `opens` indicado que no se puede abrir `com.example.tablasfx.models`:
![[Pasted image 20250313155825.png]]
los `opens` permite indicar los paquetes a los que se puede tener acceso, es necesario añadirlos para poder acceder con JavaFX
![[Pasted image 20250313160413.png]]