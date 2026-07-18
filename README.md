# 🏪 Tiendita - Gestión para Pequeños Negocios

App móvil para gestionar ventas, compras y gastos de pequeños negocios.

## 📱 Sistema Operativos
- Android
- Ios (proximamente)

## 🧰 Tecnologías
- Flutter/Dart
- Drift (Base de datos local)
- Riverpod
- LocalAuth 
- ImagePicker 
- FilePicker 
- SharePlus 
- Excel 
- Pdf
- fl_chart 
- sqlite3
- shared_preferences
- pinput

## ✨ Características
-  Control de ventas
-  Registro de compras
-  Seguimiento de gastos
-  Inventario de productos
-  Autenticación biométrica/PIN
-  Exportacion Exportación: Exportación de reportes a PDF/Excel.

## 🏗️ Arquitectura del Proyecto
<p>El proyecto está estructurado siguiendo un enfoque modular (por ejemplo, Feature-First), separando claramente las responsabilidades para mantener el código escalable y fácil de mantener:</p>

- Capa de Presentación: Interfaz de usuario construida en Flutter, reaccionando a los cambios de estado.

- Gestión de Estado: Manejada de forma reactiva y segura utilizando Riverpod.

- Capa de Datos: Persistencia local estructurada y tipada utilizando Drift y SQLite3.

- Capa de Modelos: Define las entidades, clases principales y estructuras de datos que representan la lógica de negocio de la aplicación.


## 📦 Instalación
<p>Para instalar todas las dependencias, ejecute el siguiente comando en la terminal.</p>
```bash
flutter pub get
```

<p>Para generar el código necesario para la base de datos, ejecute el siguiente comando en la terminal.</p>
```bash
dart run build_runner build --delete-conflicting-outputs
```