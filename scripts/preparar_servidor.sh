#!/usr/bin/env bash
# preparar_servidor.sh — Deja el servidor de la U.E. Horizonte listo para los próximos laboratorios.
# Uso:  sudo bash preparar_servidor.sh <tu_usuario>
# Es IDEMPOTENTE: se puede ejecutar varias veces sin romper nada (cada paso comprueba antes de actuar).
set -euo pipefail

USUARIO="${1:-}"
if [[ $EUID -ne 0 ]]; then echo "Ejecuta con sudo: sudo bash $0 <usuario>"; exit 1; fi
if [[ -z "$USUARIO" ]]; then echo "Falta el usuario: sudo bash $0 <usuario>"; exit 1; fi

paso() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

paso "1. Nombre del servidor y zona horaria"
hostnamectl set-hostname srv-horizonte 2>/dev/null || echo srv-horizonte > /etc/hostname
timedatectl set-timezone America/La_Paz 2>/dev/null || ln -sf /usr/share/zoneinfo/America/La_Paz /etc/localtime

paso "2. Paquetes base"
apt-get update -qq
apt-get install -y -qq curl htop tree ufw unattended-upgrades >/dev/null
echo "Actualizaciones pendientes: $(apt list --upgradable 2>/dev/null | grep -c upgradable || true)"

paso "3. Usuario administrador con sudo"
if ! id "$USUARIO" &>/dev/null; then
  adduser --disabled-password --gecos "Administrador Horizonte" "$USUARIO"
fi
usermod -aG sudo "$USUARIO"

paso "4. Grupo webadmin y carpeta del sitio"
getent group webadmin >/dev/null || groupadd webadmin
usermod -aG webadmin "$USUARIO"
install -d -o root -g webadmin -m 2775 /srv/horizonte /srv/horizonte/www /srv/horizonte/portal
[[ -f /srv/horizonte/www/index.html ]] || cat > /srv/horizonte/www/index.html <<'HTML'
<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><title>Unidad Educativa Horizonte</title></head>
<body><h1>Unidad Educativa Horizonte</h1><p>Sitio en construcción — servidor srv-horizonte.</p></body></html>
HTML
chgrp webadmin /srv/horizonte/www/index.html && chmod 664 /srv/horizonte/www/index.html

paso "5. Nombres locales (hasta que tengamos DNS propio en la clase 7)"
for nombre in www.horizonte.internal portal.horizonte.internal; do
  grep -q " $nombre" /etc/hosts || echo "127.0.1.1 $nombre" >> /etc/hosts
done

paso "6. Servicio SSH habilitado y activo"
systemctl enable --now ssh

paso "Resumen"
echo "Usuario: $USUARIO  →  grupos: $(id -nG "$USUARIO")"
ls -ld /srv/horizonte /srv/horizonte/www
systemctl is-active ssh
