# DAM_PROYECTO
Perfecto madre, aquí tienes una **documentación corta, clara y profesional del proyecto *DAM_Proyecto***.
Es ideal para poner en el **README.md** de GitHub o entregarlo como descripción general del repositorio.

---

# 📘 Documentación del Proyecto

## **DAM_Proyecto**

### 📌 **Descripción General**

El proyecto **DAM_Proyecto** es una aplicación desarrollada en Flutter como parte del curso *Desarrollo de Aplicaciones Móviles (DAM)*.
El objetivo principal es crear una aplicación móvil funcional que permita gestionar eventos, usuarios y funcionalidades relacionadas con inscripción, visualización y detalles de cada evento utilizando Firebase como backend.

Este repositorio contiene la estructura completa del proyecto Flutter, incluyendo las carpetas de plataforma (Android, iOS, Web), código fuente dentro de `lib/`, archivos de configuración y dependencias necesarias.

---

## 🏗 **Arquitectura del Proyecto**

El proyecto utiliza una estructura estándar de Flutter organizada de la siguiente forma:

```
/lib
    /pages          → Pantallas principales (UI)
    /widgets        → Componentes reutilizables
    /services       → Lógica de conexión a Firebase (Firestore/Auth)
    /models         → Modelos opcionales de datos
/android           → Configuración y archivos para ejecutar en Android
/ios               → Configuración y estructura para iOS
/web               → Archivos base si se despliega en Web
assets/            → Imágenes, fuentes y otros recursos
pubspec.yaml       → Dependencias y configuración general
```

---

## 🔥 **Tecnologías Utilizadas**

### **Frontend / Aplicación**

* **Flutter 3.x**
* **Dart**
* **Material Design Icons**
* **Widgets personalizados**

### **Backend / Servicios**

* **Firebase Authentication**
* **Cloud Firestore**
* **Firebase Core**

### **Herramientas**

* **Git** y **GitKraken** para control de versiones
* **GitHub** como repositorio remoto
* **Android Studio / VS Code** como entornos de desarrollo

---

## 🎯 **Objetivo Principal del Proyecto**

Desarrollar una aplicación móvil que permita a los usuarios:

* Registrarse e iniciar sesión con Google
* Ver una lista de eventos
* Consultar detalles de un evento
* Crear y publicar eventos
* Ver categorías almacenadas en Firestore
* Mostrar información con diseño moderno (gradientes, iconos, etc.)

---

## 📂 **Principales Archivos**

### **`main.dart`**

Punto de entrada de la app. Inicializa Firebase y carga la vista inicial mediante `AuthWrapper`.

### **`auth_wrapper.dart`**

Determina si el usuario está autenticado:

* Si está logeado → Redirige a la App
* Si no está logeado → Muestra pantalla de login

### **`fs_service.dart`**

Servicio que gestiona operaciones con Firestore:

* Obtener eventos
* Registrar nuevos documentos
* Consultar evento por ID
* Filtrado por usuario creador

### **Vistas (Pages)**

Ejemplos típicos:

* `eventos_pendientes_page.dart`
* `detalle_evento_page.dart`
* `login_page.dart`
* `form_evento_page.dart`

---

## 📦 **Dependencias Principales (pubspec.yaml)**

```yaml
firebase_core: 
firebase_auth:
cloud_firestore:
material_design_icons_flutter:
intl:
```

---

## 🚀 **Cómo Ejecutar el Proyecto**

1. Instalar dependencias:

   ```
   flutter pub get
   ```
2. Conectar dispositivo o emulador
3. Ejecutar:

   ```
   flutter run
   ```

---

## 👤 **Autor**

* **@ykkna i**
  Desarrollo para asignatura DAM — UTFSM.

---

Si quieres, madre, te puedo generar:

✔ Un README **más largo y profesional**
✔ Uno estilo **empresa**, con tabla de contenidos
✔ Uno más **simple y corto**
✔ O documentación interna (services / pages / widgets)

¿Quieres que lo haga más técnico o más presentable para GitHub?
