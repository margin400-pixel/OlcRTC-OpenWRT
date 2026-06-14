#!/bin/sh
# OlcRTC OpenWRT Installer v2.0 (Fixed & Complete)

REPO="margin400-pixel/OlcRTC-OpenWRT"
BRANCH="update-panel"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"

echo "==> OlcRTC: Начинаю чистую установку..."

# 1. Очистка предыдущих версий
echo "==> Очистка старых файлов..."
rm -f /etc/config/olcrtc /etc/init.d/olcrtc /tmp/olcrtc.yaml
rm -rf /www/luci-static/resources/view/olcrtc
rm -f /usr/share/luci/menu.d/luci-app-olcrtc.json
rm -f /usr/share/rpcd/acl.d/luci-app-olcrtc.json

# 2. Создание директорий
mkdir -p /www/luci-static/resources/view/olcrtc
mkdir -p /usr/share/luci/menu.d
mkdir -p /usr/share/rpcd/acl.d

# 3. Скачивание основных файлов
echo "==> Скачивание компонентов..."
wget -qO /etc/config/olcrtc "$BASE_URL/files/etc/config/olcrtc" || { echo "❌ Ошибка скачивания конфига"; exit 1; }
wget -qO /etc/init.d/olcrtc "$BASE_URL/files/etc/init.d/olcrtc" || { echo "❌ Ошибка скачивания init.d"; exit 1; }
wget -qO /www/luci-static/resources/view/olcrtc/main.js "$BASE_URL/files/www/luci-static/resources/view/olcrtc/main.js" || { echo "❌ Ошибка скачивания main.js"; exit 1; }

# 4. Создание ACL и Menu (вшиваем в скрипт для надёжности)
echo "==> Создание интеграции LuCI..."
cat > /usr/share/rpcd/acl.d/luci-app-olcrtc.json << 'EOF'
{
	"luci-app-olcrtc": {
		"description": "Grant access to OlcRTC configuration",
		"read": { "uci": [ "olcrtc" ] },
		"write": { "uci": [ "olcrtc" ] }
	}
}
EOF

cat > /usr/share/luci/menu.d/luci-app-olcrtc.json << 'EOF'
{
	"admin/services/olcrtc": {
		"title": "OlcRTC",
		"order": 60,
		"action": {
			"type": "view",
			"path": "olcrtc/main"
		},
		"depends": { "acl": [ "luci-app-olcrtc" ] }
	}
}
EOF

# 5. Права и перезапуск
chmod +x /etc/init.d/olcrtc
/etc/init.d/rpcd restart
/etc/init.d/uhttpd restart
rm -rf /tmp/luci-modulecache/*
rm -f /tmp/luci-indexcache.*

echo "✅ Установка OlcRTC завершена успешно!"
echo "📌 Панель: Службы → OlcRTC"
echo "🔄 Если не появилась: обновите страницу браузера (Ctrl+F5)"