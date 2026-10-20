<div align="center">

# 🏫 Actividad 1 — Servidor Web U.E. Horizonte
### Infraestructura, Despliegue Web y Seguridad

[![Ubuntu](https://img.shields.io/badge/Ubuntu_24.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)](https://nginx.org/)
[![PHP](https://img.shields.io/badge/PHP_8.3-777BB4?style=for-the-badge&logo=php&logoColor=white)](https://www.php.net/)
[![Python](https://img.shields.io/badge/Python_3-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)

**Institución:** Universidad Privada Domingo Savio (UPDS)  
**Materia:** Tecnología Web I  
**Grupo:** LOS REZAGADOS  

</div>

---

## 📋 Tabla de Contenidos
1. [Introducción y Resumen Ejecutivo](#-introducción-y-resumen-ejecutivo)
2. [Fundamento Teórico](#-fundamento-teórico)
3. [Arquitectura del Sistema](#-arquitectura-del-sistema)
4. [Seguridad y Hardening](#-seguridad-y-hardening)
5. [Estructura del Repositorio](#-estructura-del-repositorio)
6. [Guía de Despliegue (Quick Start)](#-guía-de-despliegue-quick-start)
7. [Documentación Adjunta](#-documentación-adjunta)
8. [Integrantes del Equipo](#-integrantes-del-equipo)

---

## 🎯 Introducción y Resumen Ejecutivo

El presente proyecto documenta y automatiza la implementación de un servidor web corporativo para la simulación de la **Unidad Educativa (U.E.) Horizonte**. A lo largo de los laboratorios 2, 3 y 4, se ha evolucionado desde la administración básica de un sistema operativo Linux hasta la configuración de un entorno de producción moderno, seguro y escalable.

El sistema final, orquestado mediante **Docker**, emula un servidor **Ubuntu Server 24.04** real. En él se despliegan dos sitios web (el institucional y el portal de padres), se configuran servidores de aplicaciones para lenguajes dinámicos (PHP y Python), y se aplican estrictas medidas de ciberseguridad para proteger las sesiones y los datos de los usuarios.

---

## 📚 Fundamento Teórico

Para la correcta implementación de esta actividad, se aplicaron los siguientes conceptos fundamentales de la tecnología web:

### 1. El Viaje de una Petición HTTP
Cuando un usuario ingresa una URL, ocurre una secuencia compleja:
1. **Resolución DNS:** El navegador traduce el nombre de dominio (ej. `www.horizonte.internal`) a una dirección IP.
2. **Handshake TCP:** Se establece una conexión fiable mediante el protocolo de control de transmisión (el cliente y el servidor "se dan la mano").
3. **Petición y Respuesta HTTP:** El cliente envía un método (GET, POST) y el servidor responde con un código de estado (200 OK, 301 Moved, 404 Not Found, 500 Internal Server Error) junto con las cabeceras y el cuerpo (HTML, JSON, etc.).

### 2. Virtual Hosts y la Cabecera `Host`
Un solo servidor físico (una sola IP) puede alojar múltiples páginas web. Nginx logra esto leyendo la cabecera `Host` que envía el navegador. Si la cabecera dice `portal.horizonte.internal`, Nginx entrega los archivos del portal; si dice `www.horizonte.internal`, entrega el sitio institucional. Si el dominio no está registrado, el servidor rechaza la conexión (código 444).

### 3. Proxy Inverso vs. Servidor de Aplicaciones (FastCGI)
*   **FastCGI (PHP-FPM):** Nginx no sabe ejecutar código PHP por sí solo. Para ello, se comunica con un proceso llamado PHP-FPM mediante un *Socket Unix*. Esto es mucho más rápido que usar la red TCP, ya que la comunicación ocurre internamente en el disco del servidor.
*   **Proxy Inverso HTTP:** Para la API de Python, Nginx actúa como un "mensajero" (proxy). Recibe la petición del cliente, se la pasa a la API de Python (que corre en un puerto local como el 8081), recibe la respuesta y se la devuelve al cliente. Esto permite actualizar el backend sin afectar al frontend.

### 4. Gestión de Sesiones y Cookies
El protocolo HTTP es "sin estado" (no recuerda quién eres entre una página y otra). Para mantener a un padre logueado en el portal, se utilizan **cookies**. El servidor envía una cookie con un ID de sesión; el navegador la guarda y la reenvía en cada petición. Los datos sensibles (nombre, notas del hijo) se guardan en el servidor (en `/var/lib/php/sessions`), no en la cookie.

---

## 🏗️ Arquitectura del Sistema

El flujo de las peticiones está diseñado para garantizar alto rendimiento y seguridad:

```mermaid
graph TD
    Client[Cliente / Navegador] -->|HTTP :8080| Nginx{Nginx Reverse Proxy}
    
    Nginx -->|Host: www.horizonte| Static[Sitio Estático<br/>HTML/CSS]
    Nginx -->|Host: portal.horizonte| PHP[PHP-FPM 8.3<br/>Socket Unix]
    Nginx -->|Ruta: /api/| Python[API Python<br/>127.0.0.1:8081]
    
    PHP -.->|Sesiones| Local[(Almacenamiento<br/>Local del Servidor)]
    Python -.->|systemd| Service[horizonte-eco.service]
