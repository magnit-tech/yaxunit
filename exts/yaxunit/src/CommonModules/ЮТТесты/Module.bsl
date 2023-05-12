//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2023 BIA-Technologies Limited Liability Company
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

/////////////////////////////////////////////////////////////////////////////////
// Содержит методы создания тестов и тестовых наборов
/////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает и регистрирует тестовый набор, в который будут добавляться последующие тесты
// Параметры:
//  Имя - Строка -  Имя набора тестов
//  ТегиСтрокой - Строка - Теги относящиеся к набору и вложенным тестам. Это строка разделенная запятыми
// 
// Возвращаемое значение:
//  ОбщийМодуль - Этот же модуль, для замыкания
Функция ДобавитьТестовыйНабор(Имя, ТегиСтрокой = "") Экспорт
	
	ИсполняемыеСценарии = СценарииМодуля();
	
	Если Не ЭтоИсполняемыеСценарии(ИсполняемыеСценарии) Тогда
		ВызватьИсключение "Первый параметр должен быть результатом метода ЮТТесты.ИсполняемыеСценарии";
	КонецЕсли;
	
	Если ПустаяСтрока(Имя) Тогда
		ВызватьИсключение "Имя тестового набора не может быть пустым";
	КонецЕсли;
	
	Контекст = Контекст();
	НовыйТестовыйНабор = ЮТФабрика.ОписаниеТестовогоНабора(Имя, ТегиСтрокой);
	
	ИсполняемыеСценарии.ТестовыеНаборы.Добавить(НовыйТестовыйНабор);
	Контекст.ТекущийНабор = НовыйТестовыйНабор;
	Контекст.ТекущийЭлемент = НовыйТестовыйНабор;
	
	Возврат ЮТТесты;
	
КонецФункции

// Регистрирует тест, исполняемый в контекстах, в которых доступен тестовый модуль.
//  Например
//  
//  * Если модуль с тестами клиент-серверный, то тест будет вызван и на клиенте и на сервере.
//  * Если клиентский, то только на клиенте.
//  * Если клиент обычное приложение, то только при запуске в режиме обычного приложения.
//  
// Параметры:
//  ИмяТестовогоМетода - Строка - Имя тестового метода
//  ПредставлениеТеста - Строка - Представление теста
//  ТегиСтрокой - Строка - Теги строкой. Это строка разделенная запятыми
//  Контексты - Строка - Контексты, строка перечисления контекстов вызова, разделенных запятой.
//                       Возможные значения см. ЮТФабрика.КонтекстыВызова
// Возвращаемое значение:
//  ОбщийМодуль - Этот же модуль, для замыкания
Функция ДобавитьТест(ИмяТестовогоМетода, ПредставлениеТеста = "", ТегиСтрокой = "", Контексты = Неопределено) Экспорт
	
	Контекст = Контекст();
	Набор = Контекст.ТекущийНабор;
	
	ЭтоИсполняемыеСценарии = ЭтоИсполняемыеСценарии(Набор);
	ЭтоТестовыйНабор = ЭтоТестовыйНабор(Набор);
	
	Если Не (ЭтоИсполняемыеСценарии Или ЭтоТестовыйНабор) Тогда
		ВызватьИсключение "Первый параметр должен быть результатом метода ЮТТесты.ИсполняемыеСценарии или ЮТТесты.ТестовыйНабор";
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяТестовогоМетода) Тогда
		ВызватьИсключение "Имя тестового метода не может быть пустым";
	КонецЕсли;
	
	Тест = ОписаниеТеста(ИмяТестовогоМетода, ПредставлениеТеста, ТегиСтрокой, Контексты);
	Набор.Тесты.Добавить(Тест);
	Контекст.ТекущийЭлемент = Тест;
	
	Возврат ЮТТесты;
	
КонецФункции

// Регистрирует тест исполняемый на клиенте.
// 
// Параметры:
//  ИмяТестовогоМетода - Строка - Имя тестового метода
//  ПредставлениеТеста - Строка - Представление теста
//  ТегиСтрокой - Строка - Теги строкой. Это строка разделенная запятыми
// 
// Возвращаемое значение:
//  ОбщийМодуль - Этот же модуль, для замыкания
Функция ДобавитьКлиентскийТест(ИмяТестовогоМетода, ПредставлениеТеста = "", ТегиСтрокой = "") Экспорт
	
	ДобавитьТест(ИмяТестовогоМетода, ПредставлениеТеста, ТегиСтрокой, КонтекстыВызоваКлиента());
	Возврат ЮТТесты;
	
КонецФункции

// Регистрирует тест исполняемый на сервере.
// 
// Параметры:
//  ИмяТестовогоМетода - Строка - Имя тестового метода
//  ПредставлениеТеста - Строка - Представление теста
//  ТегиСтрокой - Строка - Теги строкой. Это строка разделенная запятыми
// 
// Возвращаемое значение:
//  ОбщийМодуль - Этот же модуль, для замыкания
Функция ДобавитьСерверныйТест(ИмяТестовогоМетода, ПредставлениеТеста = "", ТегиСтрокой = "") Экспорт
	
	Режимы = ЮТФабрика.КонтекстыВызова();
	
	ДобавитьТест(ИмяТестовогоМетода, ПредставлениеТеста, ТегиСтрокой, Режимы.Сервер);
	
	Возврат ЮТТесты;
	
КонецФункции

// Устанавливает настройку выполнения тестового метода.
// 
// Параметры:
//  ИмяПараметра - Строка
//  Значение - Произвольный - Значение настройки 
// 
// Возвращаемое значение:
//  ОбщийМодуль - Этот же модуль, для замыкания
Функция НастройкаИсполнения(ИмяПараметра, Значение) Экспорт
	
	Контекст = Контекст();
	
	Если Контекст.ТекущийЭлемент = Неопределено Тогда
		ВызватьИсключение "Не инициализированы настройки регистрации тестов";
	КонецЕсли;
	
	Контекст.ТекущийЭлемент.НастройкиВыполнения.Вставить(ИмяПараметра, Значение);
	
	Возврат ЮТТесты;
	
КонецФункции

// Устанавливает настройку выполнения тестового метода в транзакции.
// 
// Параметры:
//  ВыполнятьВТранзакции - Булево
// 
// Возвращаемое значение:
//  ОбщийМодуль - Этот же модуль, для замыкания
Функция ВТранзакции(ВыполнятьВТранзакции = Истина) Экспорт
	
	НастройкаИсполнения(ЮТФабрика.ПараметрыИсполненияТеста().ВТранзакции, ВыполнятьВТранзакции);
	
	Возврат ЮТТесты;
	
КонецФункции

// Устанавливает настройку удаления созданных тестовых данных
// В отличии от использования транзакции:
// 
//  * Умеет работь с данными созданными на клиенте
//  * Только удаляет созданные данные и не откатывает изменения объектов
//  * Работает с данными созданными через API работы с тестовыми данными
//  * Удаляет данные созданные вне теста (в обработчиках событий, например, ПередТестовымНабором)
// 
// Параметры:
//  УдалятьСозданныеДанные - Булево
// 
// Возвращаемое значение:
//  ОбщийМодуль - Этот же модуль, для замыкания
Функция УдалениеТестовыхДанных(УдалятьСозданныеДанные = Истина) Экспорт
	
	НастройкаИсполнения(ЮТФабрика.ПараметрыИсполненияТеста().УдалениеТестовыхДанных, УдалятьСозданныеДанные);
	
	Возврат ЮТТесты;
	
КонецФункции

// Устанавливает параметры вызова теста.
// 
// * Если метод вызывается первый раз, то он устанавливает параметры теста.
// * Если второй и последующие, то добавляет новый тест с параметрами.
// 
// Параметры:
//  Параметр1 - Произвольный
//  Параметр2 - Произвольный
//  Параметр3 - Произвольный
//  Параметр4 - Произвольный
//  Параметр5 - Произвольный
//  Параметр6 - Произвольный
//  Параметр7 - Произвольный
//  Параметр8 - Произвольный
//  Параметр9 - Произвольный
//  Параметр10 - Произвольный
// 
// Возвращаемое значение:
//  ОбщийМодуль - Этот же модуль, для замыкания
// 
// Примеры:
// 
// ЮТТесты.ДобавитьТест("Тест1").СПараметрами(1, 2); // Будет зарегистрирован один тест с параметрами 1, 2
// ЮТТесты.ДобавитьТест("Тест1")
// 	.СПараметрами(1)
// 	.СПараметрами(2); // Будет зарегистрировано два теста, первый с параметром 1 и второй с параметром 2
// 
Функция СПараметрами(Параметр1 = "_!%*",
						 Параметр2 = "_!%*",
						 Параметр3 = "_!%*",
						 Параметр4 = "_!%*",
						 Параметр5 = "_!%*",
						 Параметр6 = "_!%*",
						 Параметр7 = "_!%*",
						 Параметр8 = "_!%*",
						 Параметр9 = "_!%*",
						 Параметр10 = "_!%*") Экспорт
	
	Параметры = ЮТОбщий.ЗначениеВМассиве(Параметр1,
											 Параметр2,
											 Параметр3,
											 Параметр4,
											 Параметр5,
											 Параметр6,
											 Параметр7,
											 Параметр8,
											 Параметр9,
											 Параметр10);
	
	Контекст = Контекст();
	
	Если Контекст.ТекущийЭлемент = Неопределено Тогда
		ВызватьИсключение "Не инициализированы настройки регистрации тестов";
	ИначеЕсли НЕ ЭтоОписаниеТеста(Контекст.ТекущийЭлемент) Тогда
		ВызватьИсключение "Параметры устанавливаются только для теста";
	КонецЕсли;
	
	Если Контекст.ТекущийЭлемент.Параметры <> Неопределено Тогда
		Копия = ЮТФабрика.ОписаниеТеста(Неопределено, Неопределено, Неопределено);
		ЗаполнитьЗначенияСвойств(Копия, Контекст.ТекущийЭлемент);
		Контекст.ТекущийНабор.Тесты.Добавить(Копия);
		Контекст.ТекущийЭлемент = Копия;
	КонецЕсли;
	
	Контекст.ТекущийЭлемент.Параметры = Параметры;
	
	Возврат ЮТТесты;
	
КонецФункции

#Область Устаревшие

// Регистрирует тест.
// Deprecate
// 
// Параметры:
//  ИмяТестовогоМетода - Строка - Имя тестового метода
//  ПредставлениеТеста - Строка - Представление теста
//  ТегиСтрокой - Строка - Теги строкой. Это строка разделенная запятыми
//  Контексты - Строка - Контексты, строка перечисления контекстов вызова, разделенных запятой.
//                       Возможные значения см. ЮТФабрика.КонтекстыВызова
// Возвращаемое значение:
//  ОбщийМодуль - Этот же модуль, для замыкания
Функция Тест(ИмяТестовогоМетода, ПредставлениеТеста = "", ТегиСтрокой = "", Контексты = Неопределено) Экспорт
	
	ЮТОбщий.ВызовУстаревшегоМетода("ЮТТесты.Тест", "ЮТТесты.ДобавитьТест");
	Возврат ДобавитьТест(ИмяТестовогоМетода, ПредставлениеТеста, ТегиСтрокой, Контексты);
	
КонецФункции

// Регистрирует тест вызываемый на клиенте.
// Deprecate
// 
// Параметры:
//  ИмяТестовогоМетода - Строка - Имя тестового метода
//  ПредставлениеТеста - Строка - Представление теста
//  ТегиСтрокой - Строка - Теги строкой. Это строка разделенная запятыми
// 
// Возвращаемое значение:
//  ОбщийМодуль - Этот же модуль, для замыкания
Функция ТестКлиент(ИмяТестовогоМетода, ПредставлениеТеста = "", ТегиСтрокой = "") Экспорт
	
	ЮТОбщий.ВызовУстаревшегоМетода("ЮТТесты.ТестКлиент", "ЮТТесты.ДобавитьКлиентскийТест");
	Возврат ДобавитьКлиентскийТест(ИмяТестовогоМетода, ПредставлениеТеста, ТегиСтрокой);
	
КонецФункции

// Регистрирует тест вызываемый на сервере.
// Deprecate
// 
// Параметры:
//  ИмяТестовогоМетода - Строка - Имя тестового метода
//  ПредставлениеТеста - Строка - Представление теста
//  ТегиСтрокой - Строка - Теги строкой. Это строка разделенная запятыми
// 
// Возвращаемое значение:
//  ОбщийМодуль - Этот же модуль, для замыкания
Функция ТестСервер(ИмяТестовогоМетода, ПредставлениеТеста = "", ТегиСтрокой = "") Экспорт
	
	ЮТОбщий.ВызовУстаревшегоМетода("ЮТТесты.ТестСервер", "ЮТТесты.ДобавитьСерверныйТест");
	Возврат ДобавитьСерверныйТест(ИмяТестовогоМетода, ПредставлениеТеста, ТегиСтрокой);
	
КонецФункции

// Создает и регистрирует набор, в который будут добавляться последующие тесты.
// Deprecate
// 
// Параметры:
//  Имя - Строка -  Имя набора тестов
//  ТегиСтрокой - Строка - Теги относящиеся к набору и вложенным тестам. Это строка разделенная запятыми
// 
// Возвращаемое значение:
//  ОбщийМодуль - Этот же модуль, для замыкания
Функция ТестовыйНабор(Имя, ТегиСтрокой = "") Экспорт
	
	ЮТОбщий.ВызовУстаревшегоМетода("ЮТТесты.ТестовыйНабор", "ЮТТесты.ДобавитьТестовыйНабор");
	Возврат ДобавитьТестовыйНабор(Имя, ТегиСтрокой);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПередЧтениемСценариевМодуля(МетаданныеМодуля) Экспорт
	
	ИнициализироватьКонтекст(МетаданныеМодуля);
	
	ЮТСобытия.ПередЧтениемСценариевМодуля(МетаданныеМодуля);
	
КонецПроцедуры

Процедура ПослеЧтенияСценариевМодуля() Экспорт
	
	Контекст = Контекст();
	ЮТСобытия.ПослеЧтенияСценариевМодуля(Контекст.МетаданныеМодуля, Контекст.ИсполняемыеСценарии);
	
КонецПроцедуры

// Описание сценариев модуля
// 
// Возвращаемое значение:
//  Структура - см. ИсполняемыеСценарии
Функция СценарииМодуля() Экспорт
	
	Возврат Контекст().ИсполняемыеСценарии;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Исполняемые сценарии.
// 
// Параметры:
//  МетаданныеМодуля - см. ЮТФабрика.ОписаниеМодуля
// 
// Возвращаемое значение:
//  Структура - Исполняемые сценарии:
// * ТестовыеНаборы - Массив из см. ЮТФабрика.ОписаниеТестовогоНабора - Тестовые наборы модуля
Функция ИсполняемыеСценарии(МетаданныеМодуля)
	
	Структура = Новый Структура;
	Структура.Вставить("ТестовыеНаборы", Новый Массив());
	
	Набор = ЮТФабрика.ОписаниеТестовогоНабора(МетаданныеМодуля.Имя);
	Структура.ТестовыеНаборы.Добавить(Набор);
	
	Возврат Структура;
	
КонецФункции

Функция КонтекстыВызоваКлиента()
	
	Режимы = ЮТФабрика.КонтекстыВызова();
	Возврат ЮТОбщий.ЗначениеВМассиве(Режимы.КлиентУправляемоеПриложение, Режимы.КлиентОбычноеПриложение);
	
КонецФункции

Функция КонтекстыВызоваПоУмолчанию()
	
	Возврат ЮТФабрика.КонтекстыМодуля(Контекст().МетаданныеМодуля);
	
КонецФункции

Функция ОписаниеТеста(Имя, Знач Представление, ТегиСтрокой, Знач Контексты)
	
	Если НЕ ЗначениеЗаполнено(Контексты) Тогда
		Контексты = КонтекстыВызоваПоУмолчанию();
	ИначеЕсли ТипЗнч(Контексты) = Тип("Строка") Тогда
		Контексты = СтрРазделить(Контексты, ", ", Ложь);
	КонецЕсли;
	
	Возврат ЮТФабрика.ОписаниеТеста(Имя, Представление, Контексты, ТегиСтрокой);
	
КонецФункции

Функция ЭтоИсполняемыеСценарии(ИсполняемыеСценарии)
	
	Возврат ТипЗнч(ИсполняемыеСценарии) = Тип("Структура")
		И ТипЗнч(ЮТОбщий.ЗначениеСтруктуры(ИсполняемыеСценарии, "ТестовыеНаборы")) = Тип("Массив");
	
КонецФункции

Функция ЭтоТестовыйНабор(ТестовыйНабор)
	
	Возврат ТипЗнч(ТестовыйНабор) = Тип("Структура")
		И ТипЗнч(ЮТОбщий.ЗначениеСтруктуры(ТестовыйНабор, "Тесты")) = Тип("Массив");
	
КонецФункции

Функция ЭтоОписаниеТеста(Описание)
	
	Возврат ТипЗнч(Описание) = Тип("Структура")
		И ТипЗнч(ЮТОбщий.ЗначениеСтруктуры(Описание, "КонтекстВызова")) = Тип("Массив");
	
КонецФункции

#Область Контекст

Функция Контекст()
	
	Возврат ЮТКонтекст.ЗначениеКонтекста("КонтекстРегистрацияТестов");
	
КонецФункции

Процедура ИнициализироватьКонтекст(МетаданныеМодуля)
	
	ИсполняемыеСценарии = ИсполняемыеСценарии(МетаданныеМодуля);
	Набор = ИсполняемыеСценарии.ТестовыеНаборы[0];
	
	Контекст = Новый Структура();
	
	Контекст.Вставить("МетаданныеМодуля", МетаданныеМодуля);
	Контекст.Вставить("ИсполняемыеСценарии", ИсполняемыеСценарии);
	Контекст.Вставить("ТекущийНабор", Набор);
	Контекст.Вставить("ТекущийЭлемент", Набор);
	
	ЮТКонтекст.УстановитьЗначениеКонтекста("КонтекстРегистрацияТестов", Контекст);
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти
