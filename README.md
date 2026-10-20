<div align="center">

# 🏫 Actividad 1 — Servidor Web U.E. Horizonte

**Proyecto de Infraestructura y Despliegue Web**

[![Ubuntu](https://img.shields.io/badge/Ubuntu_24.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)](https://nginx.org/)
[![PHP](https://img.shields.io/badge/PHP_8.3-777BB4?style=for-the-badge&logo=php&logoColor=white)](https://www.php.net/)
[![Python](https://img.shields.io/badge/Python_3-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Bash](https://img.shields.io/badge/GNU_Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)

**Institución:** Universidad Privada Domingo Savio (UPDS)  
**Materia:** Tecnología Web I  
**Grupo:** LOS REZAGADOS  

</div>

---

## 📋 Tabla de Contenidos
1. [Descripción General](#-descripción-general)
2. [Arquitectura del Sistema](#-arquitectura-del-sistema)
3. [Stack Tecnológico y Componentes](#-stack-tecnológico-y-componentes)
4. [Seguridad y Hardening](#-seguridad-y-hardening)
5. [Estructura del Repositorio](#-estructura-del-repositorio)
6. [Guía de Despliegue (Quick Start)](#-guía-de-despliegue-quick-start)
7. [Documentación Adjunta](#-documentación-adjunta)
8. [Integrantes del Equipo](#-integrantes-del-equipo)

---

## 🎯 Descripción General

Este repositorio consolida la solución integral para la **Actividad 1** del grupo *Los Rezagados*. El proyecto unifica los conceptos prácticos de los Laboratorios 2, 3 y 4, demostrando la capacidad de administrar un servidor **Ubuntu Server 24.04** desde la línea de comandos hasta el despliegue de aplicaciones web dinámicas.

El sistema se ejecuta en un entorno contenedorizado (Docker) que emula un servidor físico con `systemd` habilitado. A través de un proxy inverso y servidores de aplicaciones, se publican dos sitios web (institucional y portal de padres) junto con un microservicio backend en Python.

---

## 🏗️ Arquitectura del Sistema

El flujo de las peticiones está diseñado para garantizar alto rendimiento y seguridad:

```mermaid
graph TD
    Client[Cliente / Navegador] -->|HTTP :8080| Nginx{Nginx Reverse Proxy}
    
    Nginx -->|Host: www.horizonte| Static[Sitio Estático<br/>HTML/CSS]
    Nginx -->|Host: portal.horizonte| PHP[PHP-FPM 8.3<br/>Socket Unix]
    Nginx -->|Ruta: /api/| Python[API Python<br/>127.0.0.1:8081]
    
    PHP -.->|Sesiones| Redis[(Almacenamiento<br/>Local)]
    Python -.->|systemd| Service[horizonte-eco.service]
