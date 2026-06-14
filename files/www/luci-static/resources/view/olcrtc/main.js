'use strict';
'require view';
'require form';
'require uci';

return view.extend({
	load: function() {
		return uci.load('olcrtc');
	},

	render: function() {
		var m, s, o;

		m = new form.Map('olcrtc', _('OlcRTC'), _('Клиент для ретрансляции видео через WebRTC (поддержка Jitsi + datachannel).'));

		s = m.section(form.TypedSection, 'global', _('Основные настройки'));
		s.anonymous = true;

		o = s.option(form.Flag, 'enabled', _('Включить'), _('Запускать службу при старте системы'));
		o.rmempty = false;

		o = s.option(form.ListValue, 'provider', _('Провайдер'), _('Рекомендуется: jitsi'));
		o.value('jitsi', 'Jitsi (Рекомендуется)');
		o.value('telemost', 'Telemost');
		o.value('wbstream', 'WBStream');
		o.default = 'jitsi';

		o = s.option(form.ListValue, 'transport', _('Транспорт'), _('Для Jitsi настоятельно рекомендуется datachannel'));
		o.value('datachannel', 'datachannel (Макс. скорость, рекомендуется для Jitsi)');
		o.value('vp8channel', 'vp8channel');
		o.value('seichannel', 'seichannel');
		o.value('videochannel', 'videochannel');
		o.default = 'datachannel';

		o = s.option(form.Value, 'jitsi_url', _('Jitsi URL'), _('Адрес сервера Jitsi'));
		o.default = 'https://meet.small-dm.ru';
		o.depends('provider', 'jitsi');

		o = s.option(form.Value, 'room_id', _('ID Комнаты'));
		o.rmempty = false;

		o = s.option(form.Value, 'key', _('Ключ (64 HEX символа)'));
		o.password = true;
		o.rmempty = false;

		return m.render();
	}
});
