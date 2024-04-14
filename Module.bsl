﻿
&НаКлиенте
Функция ПолучитьОписание(НаименованиеТовара, Категория) Экспорт
	
	СтруктуруЗапроса = СформироватьСтруктуруЗапроса(НаименованиеТовара, Категория);
	СтрокаДляТела = СериализоватьВJSON(СтруктуруЗапроса);
	
	Результат = ОтправитьЗапросКЯндексКлауд(СтрокаДляТела);
	Если Результат.result.alternatives.Количество() > 0 Тогда
		Возврат Результат.result.alternatives[0].message.text;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаКлиенте
Функция ОтправитьЗапросКЯндексКлауд(СтрокаДляТела)
	
	// создаем новое HTTP соединение с указанием сервера
	SSL = Новый ЗащищенноеСоединениеOpenSSL();
	HTTP = Новый HTTPСоединение("llm.api.cloud.yandex.net",,,,,,SSL);
	
	//заголовок создадим в виде соответствия
	ЗаголовокЗапросаHTTP = Новый Соответствие();
	
	Токен = "t1.9euelZrIms_IyceLmcqZkpPHjc6Zm-3rnpWazJeJmJaYkpSWmZyQx8yblJvl8_cOKRNP-e8qDDA4_N3z905XEE_57yoMMDj8zef1656VmsyPms-Uj4-ZjZLOmJCRi4me7_zF656VmsyPms-Uj4-ZjZLOmJCRi4me.8XPPoGinOGeU_YibcZoXrufLc_H-Anx29fXJkdblDhpNR_yU3lyBqSY8D5aU2wHBPLXrf6q6CJK3faUVSm0wBg";
	ЗаголовокЗапросаHTTP.Вставить("Authorization", "Bearer " + Токен);
	ЗаголовокЗапросаHTTP.Вставить("Content-Type", "application/json");
	
	//создадим заголовок запроса
	ЗапросHTTP = Новый HTTPЗапрос("foundationModels/v1/completion", ЗаголовокЗапросаHTTP);
	
	//загрузить строку в тело
	ЗапросHTTP.УстановитьТелоИзСтроки(СтрокаДляТела);
	
	// Отправляем POST-запрос на обработку
	ОтветHTTP = HTTP.ОтправитьДляОбработки(ЗапросHTTP);
	JSON = ОтветHTTP.ПолучитьТелоКакСтроку();
	
	Результат = ДесериализоватьJSON(JSON);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция СериализоватьВJSON(ДанныеОКлиенте)
	
	//сериализуем в json
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, ДанныеОКлиенте);
	СтрокаДляТела = ЗаписьJSON.Закрыть();
	
	Возврат СтрокаДляТела;
	
КонецФункции

&НаКлиенте
Функция ДесериализоватьJSON(JSON)
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(JSON);
	Результат = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция СформироватьСтруктуруЗапроса(НаименованиеТовара, Категория)
	
	// Структура запроса
	modelUri = "gpt://b1gvgg6415qhiavhpheu/yandexgpt-lite";
	
	completionOptions = Новый Структура();
	completionOptions.Вставить("stream", Ложь);
	completionOptions.Вставить("temperature", 0.9);
	completionOptions.Вставить("maxTokens", 2000);
	
	messages = Новый Массив;
	
	System = Новый Структура;
	System.Вставить("role", "system");
	System.Вставить("text", "Ты — маркетолог. Напиши описание товара для маркетплейса. Используй заданные название товара и категорию.");
	
	User = Новый Структура;
	User.Вставить("role", "user");
	User.Вставить("text", "Название товара: " + НаименованиеТовара + ". " + "Категория: " + Категория);
	
	messages.Добавить(System);
	messages.Добавить(User);
	
	СтруктуруЗапроса = Новый Структура("modelUri, completionOptions, messages", modelUri, completionOptions, messages);
	
	Возврат СтруктуруЗапроса;
	
КонецФункции