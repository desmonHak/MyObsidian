```java
package com.example.tablasfx;

import com.example.tablasfx.models.Product;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.VBox;

public class HelloController {
    /*
     * Una lista observable de objetos visibles, es la forma
     * correcta de trabjar con listas/array en javaFX.
     * Permite notificar cambios o eliminaciones en la tabla
     * */
    private ObservableList<Product> products =
            FXCollections.observableArrayList(
                    new Product(
                            "Teclado",
                            "alguna descripcin",
                            1000L
                    ),
                    new Product(
                            "Raton",
                            "alguna descripcin",
                            40L
                    ),
                    new Product(
                            "USB",
                            "alguna descripcin",
                            300L
                    )
            );

    @FXML
    private VBox rootContainer;
    @FXML
    private Label welcomeText;

    @FXML
    public void initialize() {
        /*
         * Vista para los productos en forma de tabla
         * */
        TableView<Product> tableView = new TableView<>();

        /*
         * Crear columnas con descripcion
         * */
        TableColumn<Product, String> nameColum = new TableColumn<>("Nombre");
        TableColumn<Product, String> descColum = new TableColumn<>("Descripcion");
        TableColumn<Product, Long> pricColum = new TableColumn<>("Precio");

        /*
         * Es necesario poner el mismo nombre que el
         * campo tiene como atributo en su clase.
         *
         * establece que cada celda de la columna
         * nameColum obtendrá su valor llamando al metodo
         * getName() del objeto Product
         * */
        nameColum.setCellValueFactory(new PropertyValueFactory<>("name"));
        descColum.setCellValueFactory(new PropertyValueFactory<>("description"));
        pricColum.setCellValueFactory(new PropertyValueFactory<>("price"));

        /*
        * Vois permite multi-tipo
        * */
        TableColumn<Product, Void> deleteColumn= new TableColumn<>("Eliminar");

        /*
        * se usa una funcion lambda
        * Se establece la fábrica de celdas para la columna "deleteColumn"
        * usando una función lambda.
        * La lambda recibe un parámetro (no usado en este ejemplo, se podría
        * llamar "param") y devuelve un nuevo objeto TableCell.
        * */
        deleteColumn.setCellFactory(param -> new TableCell<>(){
            // Se declara un botón "Eliminar" que será el componente gráfico mostrado en la celda.
            private final Button deleteButton = new Button("Eliminar");
                {
                    // cuando se hace clic, se crea un evento que elimine el valor
                    // Bloque de inicialización anónimo que se ejecuta al
                    // crear la instancia de TableCell.
                    // Aquí se configura el botón para que, cuando se haga clic
                    // sobre él, se ejecute una acción.
                    deleteButton.setOnAction(
                            Event -> {
                                // Se obtiene el producto correspondiente a la fila actual.
                                // getTableView() devuelve la tabla a la que pertenece esta celda y getIndex() obtiene el índice de la fila.
                                Product product = getTableView().getItems().get(getIndex());
                                // Se elimina el producto obtenido de la lista de elementos de la tabla.
                                tableView.getItems().remove(product);
                            }
                    );
                }

                // sobrescribir la funcion para que no solo repinte la tabla, sino que tambien
                // pinte el boton. Personalizar el renderizado de la celda.
                @Override
                protected void updateItem(Void item, boolean empty) {
                    // Se llama a la implementación de la superclase para mantener el comportamiento estándar.
                    super.updateItem(item, empty);
                    if (empty) {
                        // Si la celda está vacía (no hay datos asociados), se
                        // remueve cualquier gráfico (por ejemplo, el botón).
                        setGraphic(null);
                    } else {
                        // Si la celda contiene datos, se establece el botón
                        // "Eliminar" como el gráfico que se muestra en la celda.
                        setGraphic(deleteButton);
                    }
                }
            }
        );


        /*
         * Se agregan todas las columnas creadas (nameColum,
         * descColum, pricColum) al TableView. Con esto, la
         * tabla está preparada para mostrar cada atributo del
         * producto en columnas separadas.
         * */
        tableView.getColumns().addAll(nameColum, descColum, pricColum, deleteColumn);
        tableView.setItems(this.products);

        // Agrega la tabla al contenedor del FXML
        rootContainer.getChildren().add(tableView);
    }

    @FXML
    protected void onHelloButtonClick() {
        welcomeText.setText("Welcome to JavaFX Application!");
    }
}
```
En el `HelloController` es necesario crear la tabla, el controlador añadirá la tabla usando `rootContainer.getChildren().add(tableView)` en la subrutina `initialize`.

Para poder referenciar a ``rootContainer`` es necesario asignar un ID al ``VBox`` principal, permitiendo crear un atributo en el controlador que tenga el control de este ``VBox``. 
![[Pasted image 20250313160216.png]]

para añadir un botón eliminar, en este caso se uso funciones anonimas:
```java
        /*
        * se usa una funcion lambda
        * Se establece la fábrica de celdas para la columna "deleteColumn"
        * usando una función lambda.
        * La lambda recibe un parámetro (no usado en este ejemplo, se podría
        * llamar "param") y devuelve un nuevo objeto TableCell.
        * */
        deleteColumn.setCellFactory(param -> new TableCell<>(){
            // Se declara un botón "Eliminar" que será el componente gráfico mostrado en la celda.
            private final Button deleteButton = new Button("Eliminar");
                {
                    // cuando se hace clic, se crea un evento que elimine el valor
                    // Bloque de inicialización anónimo que se ejecuta al
                    // crear la instancia de TableCell.
                    // Aquí se configura el botón para que, cuando se haga clic
                    // sobre él, se ejecute una acción.
                    deleteButton.setOnAction(
                            Event -> {
                                // Se obtiene el producto correspondiente a la fila actual.
                                // getTableView() devuelve la tabla a la que pertenece esta celda y getIndex() obtiene el índice de la fila.
                                Product product = getTableView().getItems().get(getIndex());
                                // Se elimina el producto obtenido de la lista de elementos de la tabla.
                                tableView.getItems().remove(product);
                            }
                    );
                }

                // sobrescribir la funcion para que no solo repinte la tabla, sino que tambien
                // pinte el boton. Personalizar el renderizado de la celda.
                @Override
                protected void updateItem(Void item, boolean empty) {
                    // Se llama a la implementación de la superclase para mantener el comportamiento estándar.
                    super.updateItem(item, empty);
                    if (empty) {
                        // Si la celda está vacía (no hay datos asociados), se
                        // remueve cualquier gráfico (por ejemplo, el botón).
                        setGraphic(null);
                    } else {
                        // Si la celda contiene datos, se establece el botón
                        // "Eliminar" como el gráfico que se muestra en la celda.
                        setGraphic(deleteButton);
                    }
                }
            }
        );
```