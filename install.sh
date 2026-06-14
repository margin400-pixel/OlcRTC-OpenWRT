#!/bin/sh
# OlcRTC OpenWRT Installer (Updated for Jitsi + YAML)

REPO="margin400-pixel/OlcRTC-OpenWRT"
BRANCH="update-panel"
RAW_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"

echo "==> Скачивание файлов OlcRTC..."

# Создаём директории
mkdir -p /usr/bin
mkdir -p /etc/config
mkdir -p /etc/init.d
mkdir -p /www/luci-static/resources/view/olcrtc

# Скачиваем файлы
wget -qO /etc/config/olcrtc "$RAW_URL/files/etc/config/olcrtc"
wget -qO /etc/init.d/olcrtc "$RAW_URL/files/etc/init.d/olcrtc"
wget -qO /www/luci-static/resources/view/olcrtc/main.js "$RAW_URL/files/www/luci-static/resources/view/olcrtc/main.js"

chmod +x /etc/init.d/olcrtc

# Миграция: если был старый 'jazz', меняем на 'jitsi'
if uci get olcrtc.@global[0].provider 2>/dev/null | grep -q "jazz"; then
    echo "==> Миграция: замена устаревшего провайдера 'jazz' на 'jitsi'..."
    uci set olcrtc.@global[0].provider='jitsi'
    uci set olcrtc.@global[0].transport='datachannel'
    uci commit olcrtc
fi

echo "==> Установка завершена!"
echo "==> Настройте OlcRTC в веб-интерфейсе LuCI (Службы -> OlcRTC)"
echo "==> Или через консоль: uci set olcrtc.@global[0].enabled='1' && uci commit && /etc/init.d/olcrtc restart"
