//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2024 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область СлужебныйПрограммныйИнтерфейс

// см. ЮТТестовыеДанные.Фикция
Функция Фикция(ОписаниеТипа, РеквизитыЗаполнения = Неопределено) Экспорт
	
	ПереданоОписаниеТипа = ТипЗнч(ОписаниеТипа) = Тип("ОписаниеТипов");
	
	Если НЕ ПереданоОписаниеТипа Тогда
		Тип = ОписаниеТипа;
	ИначеЕсли ОписаниеТипа.Типы().Количество() > 1 Тогда
		НомерТипа = ЮТТестовыеДанные.СлучайноеПоложительноеЧисло(ОписаниеТипа.Типы().Количество());
		Тип = ОписаниеТипа.Типы()[НомерТипа - 1];
	Иначе
		Тип = ОписаниеТипа.Типы()[0];
	КонецЕсли;
	
	Значение = Неопределено;
	
	Если Тип = Тип("Число") Тогда
		
		Значение = ФиктивноеЧисло(ОписаниеТипа);
		
	ИначеЕсли Тип = Тип("Строка") Тогда
		
		Значение = ФиктивнаяСтрока(ОписаниеТипа);
		
	ИначеЕсли Тип = Тип("Дата") Тогда
		
		Значение = ФиктивнаяДата(ОписаниеТипа);
		
	ИначеЕсли Тип = Тип("Булево") Тогда
		
		Значение = ЮТТестовыеДанные.СлучайноеБулево();
		
	ИначеЕсли ЮТТипыДанныхСлужебный.ЭтоСистемноеПеречисление(Тип) Тогда
		
		Значение = СлучайноЗначениеСистемногоПеречисления(Тип);
		
	Иначе
		
		Значение = ЮТТестовыеДанныеСлужебныйВызовСервера.ФикцияЗначенияБазы(Тип, РеквизитыЗаполнения);
		
	КонецЕсли;
	
	Если Значение = Неопределено Тогда
		ВызватьИсключение СтрШаблон("Создание фейковых значений для `%1` не поддерживается", ОписаниеТипа);
	КонецЕсли;
	
	Если ПереданоОписаниеТипа Тогда
		Значение = ОписаниеТипа.ПривестиЗначение(Значение);
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

Функция ФикцияЗначений(Реквизиты, РеквизитыЗаполнения = Неопределено) Экспорт
	
#Если ТонкийКлиент Тогда
	НеобходимВызовСервера = Ложь;
	
	Для Каждого Реквизит Из Реквизиты Цикл
		СодержитСсылочныйТип = ?(ТипЗнч(Реквизит.Значение) = Тип("Тип"),
								 ЮТТипыДанныхСлужебный.ЭтоСсылочныйТип(Реквизит.Значение),
								 ЮТТипыДанныхСлужебный.СодержитСсылочныйТип(Реквизит.Значение));
		Если СодержитСсылочныйТип Тогда
			НеобходимВызовСервера = Истина;
			Прервать
		КонецЕсли;
	КонецЦикла;
	
	Если НеобходимВызовСервера Тогда
		Возврат ЮТТестовыеДанныеСлужебныйВызовСервера.ФикцияЗначений(Реквизиты, РеквизитыЗаполнения);
	КонецЕсли;
#КонецЕсли
	
	Значения = Новый Структура;
	
	Для Каждого Реквизит Из Реквизиты Цикл
		Значение = Фикция(Реквизит.Значение, РеквизитыЗаполнения);
		Значения.Вставить(Реквизит.Ключ, Значение);
	КонецЦикла;
	
	Возврат Значения;
	
КонецФункции

#Если Не ВебКлиент Тогда
	
// см. ЮТТестовыеДанные.НовоеИмяВременногоФайла
Функция НовоеИмяВременногоФайла(Расширение = Неопределено) Экспорт
	
	//@skip-check missing-temporary-file-deletion
	Результат = ПолучитьИмяВременногоФайла(Расширение); // BSLLS:MissingTemporaryFileDeletion-off
	ДобавитьВременныйФайл(Результат);
	Возврат Результат;
	
КонецФункции

#КонецЕсли

Процедура ДобавитьВременныйФайл(Файл) Экспорт
	
	БуферВременныеФайлы().Добавить(Файл);
	
КонецПроцедуры

Процедура ДобавитьТестовуюЗапись(Запись) Экспорт
	
#Если Сервер Тогда
	Если ТранзакцияАктивна() И ЮТНастройкиВыполнения.ВТранзакции() Тогда
		Возврат;
	КонецЕсли;
#КонецЕсли
	Если ЮТНастройкиВыполнения.УдалениеТестовыхДанных() Тогда
		БуферТестовыеДанные().Добавить(Запись);
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьТестовыеДанные() Экспорт
	
	ЮТФайлы.УдалитьВременныеФайлы(БуферВременныеФайлы());
	
	Если ЮТНастройкиВыполнения.УдалениеТестовыхДанных() Тогда
		ЮТТестовыеДанные.Удалить(БуферТестовыеДанные(), Истина);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает соответствие с подстроками поиска и замены
//	Возвращаемое значение:
//		Соответствие из Строка
Функция ПодстрокиДляЗаменыВИменахСвойств() Экспорт
	
	ЗаменяемыеПодстроки = Новый Соответствие;
	ЗаменяемыеПодстроки.Вставить(".", "_tchk_");
	
	Возврат ЗаменяемыеПодстроки;
	
КонецФункции

#Область ОбработчикиСобытий

Процедура ПослеКаждогоТеста(ОписаниеСобытия) Экспорт
	
	УдалитьТестовыеДанные(); // Очистка тестовых данных на уровне теста
	
КонецПроцедуры

Процедура ПослеТестовогоНабора(ОписаниеСобытия) Экспорт
	
	УдалитьТестовыеДанные(); // Очистка тестовых данных на уровне теста
	
КонецПроцедуры

Процедура ПослеВсехТестов(ОписаниеСобытия) Экспорт
	
	УдалитьТестовыеДанные(); // Очистка тестовых данных на уровне теста
	
КонецПроцедуры

// Обработчик события "ИнициализацияКонтекста"
// 
// Параметры:
//  ДанныеКонтекста - Структура
Процедура ИнициализацияКонтекста(ДанныеКонтекста) Экспорт
	
#Если НЕ ВебКлиент Тогда
	ДанныеКонтекста.Вставить(ИмяКонтекстаГенераторСлучайныхЧисел(), Новый ГенераторСлучайныхЧисел());
#КонецЕсли

КонецПроцедуры

#КонецОбласти

Функция ЗагрузитьИзМакета(Макет, ОписанияТипов, КэшЗначений, ЗаменяемыеЗначения, ПараметрыСозданияОбъектов, ТаблицаЗначений) Экспорт
	
	ПараметрыЗаполнения = ЮТФабрикаСлужебный.ПараметрыЗаполненияТаблицыЗначений(ПараметрыСозданияОбъектов);
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда
	Возврат ЮТТестовыеДанныеСлужебныйСервер.ЗагрузитьИзМакета(Макет,
															  ОписанияТипов,
															  КэшЗначений,
															  ЗаменяемыеЗначения,
															  ПараметрыЗаполнения,
															  ТаблицаЗначений);
#Иначе
	Возврат ЮТТестовыеДанныеСлужебныйВызовСервера.ЗагрузитьИзМакета(Макет,
																	ОписанияТипов,
																	КэшЗначений,
																	ЗаменяемыеЗначения,
																	ПараметрыЗаполнения,
																	ТаблицаЗначений);
#КонецЕсли
	
КонецФункции

Функция ГенераторСлучайныхЧисел() Экспорт
	
	Возврат ЮТКонтекстСлужебный.ЗначениеКонтекста(ИмяКонтекстаГенераторСлучайныхЧисел());
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СлучайноЗначениеСистемногоПеречисления(Тип)
	
	Менеджер = ЮТМетодыСлужебный.ВычислитьБезопасно(ЮТТипыДанныхСлужебный.ИмяСистемногоПеречисления(Тип));
	
	Значения = Новый Массив();
	
	Для Каждого Значение Из Менеджер Цикл
		Значения.Добавить(Значение);
	КонецЦикла;
	
	Возврат ЮТТестовыеДанные.СлучайноеЗначениеИзСписка(Значения);
	
КонецФункции

Функция БуферВременныеФайлы()
	
	Возврат Буфер("ВременныеФайлы");
	
КонецФункции

Функция БуферТестовыеДанные()
	
	Возврат Буфер("ТестовыеДанные");
	
КонецФункции

Функция Буфер(Ключ)
	
	ТекущийКонтекст = ЮТест.Контекст().ТекущийКонтекст();
	
	Если ТекущийКонтекст.Свойство(Ключ) Тогда
		Буфер = ТекущийКонтекст[Ключ];
	Иначе
		Буфер = Новый Массив();
		ТекущийКонтекст.Вставить(Ключ, Буфер);
	КонецЕсли;
	
	Возврат Буфер;
	
КонецФункции

Функция ФиктивноеЧисло(ОписаниеТипа)
	
	Если ТипЗнч(ОписаниеТипа) <> Тип("ОписаниеТипов") Тогда
		Возврат ЮТТестовыеДанные.СлучайноеЧисло();
	КонецЕсли;
	
	МаксимальноеЗначение = 4294967295;
	Если ОписаниеТипа.КвалификаторыЧисла.ДопустимыйЗнак = ДопустимыйЗнак.Неотрицательный ИЛИ ЮТТестовыеДанные.СлучайноеБулево() Тогда
		МаксимальноеЗначение = ОписаниеТипа.ПривестиЗначение(МаксимальноеЗначение);
		Значение = ЮТТестовыеДанные.СлучайноеПоложительноеЧисло(МаксимальноеЗначение, ОписаниеТипа.КвалификаторыЧисла.РазрядностьДробнойЧасти);
	Иначе
		МаксимальноеЗначение = ОписаниеТипа.ПривестиЗначение(-МаксимальноеЗначение);
		Значение = ЮТТестовыеДанные.СлучайноеОтрицательноеЧисло(МаксимальноеЗначение, ОписаниеТипа.КвалификаторыЧисла.РазрядностьДробнойЧасти);
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

Функция ФиктивнаяСтрока(ОписаниеТипа)
	
	Если ТипЗнч(ОписаниеТипа) <> Тип("ОписаниеТипов") Тогда
		Возврат ЮТТестовыеДанные.СлучайнаяСтрока(ЮТТестовыеДанные.СлучайноеПоложительноеЧисло(100));
	КонецЕсли;
	
	Если ОписаниеТипа.КвалификаторыСтроки.Длина = 0 Тогда
		Значение = ЮТТестовыеДанные.СлучайнаяСтрока(ЮТТестовыеДанные.СлучайноеПоложительноеЧисло(100));
	Иначе
		Значение = ЮТТестовыеДанные.СлучайнаяСтрока(ОписаниеТипа.КвалификаторыСтроки.Длина);
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

Функция ФиктивнаяДата(ОписаниеТипа)
	
	Интервал = 315360000; // 10 лет
	//@skip-check use-non-recommended-method
	Возврат ЮТТестовыеДанные.СлучайнаяДата(ТекущаяДата() - Интервал, ТекущаяДата() + Интервал); // BSLLS:DeprecatedCurrentDate-off
	
КонецФункции

Функция ИмяКонтекстаГенераторСлучайныхЧисел()
	
	Возврат "ГенераторСлучайныхЧисел";
	
КонецФункции
#КонецОбласти
