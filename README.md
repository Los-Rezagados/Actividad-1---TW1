# 🌐 Actividad 1 — Servidor Web de la U.E. Horizonte

<div align="center">

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![PHP](https://img.shields.io/badge/php-%23777BB4.svg?style=for-the-badge&logo=php&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

**Estudiante:** Juan Marcelo Soliz Miranda  
**Universidad:** Universidad Privada Domingo Savio (UPDS)  
**Materia:** Tecnología Web I  

</div>

---

## 📖 Descripción del Proyecto

Este repositorio contiene la resolución completa de la **Actividad 1** para la materia de Tecnología Web I. El proyecto integra el trabajo realizado en los laboratorios 2, 3 y 4, demostrando la administración de un servidor Linux y el despliegue de servicios web modernos.

El entorno simula un servidor **Ubuntu Server** administrado mediante `systemd`, el cual publica dos sitios web utilizando **Nginx** como proxy inverso y servidor de archivos estáticos. Además, incluye un portal dinámico desarrollado en **PHP-FPM** con manejo seguro de sesiones, y un backend de pruebas (API de eco) desarrollado en **Python**, todo orquestado con **Docker**.

---

## 📂 Contenido del Repositorio

### 📑 1. Informes y Documentación (PDF)
Aquí se encuentran los informes detallados con las capturas de pantalla, procedimientos y reflexiones de cada laboratorio y la bitácora de uso de IA.

* 📄 [Bitácora de IA](./01-Bitacora/BitacoraIA__Laboratorios__y__Actividades.pdf)
* 📄 [Laboratorio 1 - Cliente-Servidor y curl](./02-Lab1/Lab1-Juan.pdf)
* 📄 [Laboratorio 2 - Administración de Ubuntu Server](./03-Lab2/Lab2-Juan.pdf)
* 📄 [Laboratorio 3 - Nginx con dos sitios](./04-Lab3/lab3Juan.pdf)
* 📄 [Laboratorio 4 - PHP-FPM y Proxy Inverso](./05-Lab4/Lab4juan.pdf)

### 💻 2. Código Fuente y Configuración
Aquí se aloja todo el código, scripts y archivos de configuración utilizados en el servidor.

| Carpeta | Descripción | Componentes principales |
| :--- | :--- | :--- |
| 📁 **`lab02/`** | **Administración del Servidor** | Scripts en Bash para la creación de usuarios (`preparar_servidor.sh`), configuración de red (`netplan`) y verificación del sistema. |
| 📁 **`lab03/`** | **Servidor Web con Nginx** | Archivos de configuración de Virtual Hosts (`nginx/`), sitio estático del colegio (`sitio/`) y scripts de despliegue. |
| 📁 **`lab04/`** | **Servicios Dinámicos** | Portal PHP (`portal/`), API en Python (`api/servidor_eco.py`), configuración de Nginx para FastCGI y servicios de `systemd`. |

---

## 🏗️ Arquitectura del Sistema

El proyecto se levanta sobre un contenedor de Docker que emula el servidor físico.

```text
       [ Cliente / Navegador Web ]
                   │
                   ▼
         ┌───────────────────┐
         │  Nginx (Puerto 80)│
         └─────────┬─────────┘
                   │
         ┌─────────┴─────────┐
         │                   │
         ▼                   ▼
 ┌───────────────┐   ┌───────────────┐
 │ Sitio Estático│   │  Proxy Inverso│
 │  (HTML/CSS)   │   │   (Ruta /api) │
 └───────────────┘   └───────┬───────┘
                             │
         ┌───────────────────┴───────────────────┐
         │                                       │
         ▼                                       ▼
 ┌───────────────┐                       ┌───────────────┐
 │  PHP-FPM 8.3  │                       │  API Python   │
 │ (Portal Padres│                       │ (servidor_eco)│
 │  y sesiones)  │                       │  Puerto 8081  │
 └───────────────┘                       └───────────────┘
