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

#Область СлужебныйПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт
	
	ЮТТесты.ВТранзакции().УдалениеТестовыхДанных()
		.ДобавитьТест("ЗначенияРеквизитов")
		.ДобавитьТест("ЗначениеРеквизита")
		.ДобавитьТест("ТаблицаСодержитЗаписи")
		.ДобавитьТест("РезультатЗапроса")
		.ДобавитьТест("РезультатПустой")
	;
	
КонецПроцедуры

Процедура ЗначенияРеквизитов() Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Штрихкод")
		.Фикция("Поставщик");
	Данные = Конструктор.ДанныеОбъекта();
	Ссылка = Конструктор.Записать();
	
	ДанныеСсылки = ЮТЗапросы.ЗначенияРеквизитов(Ссылка, "Наименование");
	ЮТест.ОжидаетЧто(ДанныеСсылки)
		.ИмеетТип("Структура")
		.Заполнено()
		.Свойство("Наименование").Равно(Данные.Наименование);
	
	ДанныеСсылки = ЮТЗапросы.ЗначенияРеквизитов(Ссылка, "Штрихкод, Поставщик");
	ЮТест.ОжидаетЧто(ДанныеСсылки)
		.ИмеетТип("Структура")
		.Заполнено()
		.Свойство("Штрихкод").Равно(Данные.Штрихкод)
		.Свойство("Поставщик").Равно(Данные.Поставщик);
	
	ДанныеСсылки = ЮТЗапросы.ЗначенияРеквизитов(ПредопределенноеЗначение("Справочник.Товары.ПустаяСсылка"), "Код, Поставщик");
	ЮТест.ОжидаетЧто(ДанныеСсылки)
		.ИмеетТип("Структура")
		.Заполнено()
		.Свойство("Код").Равно(Неопределено)
		.Свойство("Поставщик").Равно(Неопределено);
	
КонецПроцедуры

Процедура ЗначениеРеквизита() Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Поставщик");
	Данные = Конструктор.ДанныеОбъекта();
	Ссылка = Конструктор.Записать();
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.ЗначениеРеквизита(Ссылка, "Наименование"))
		.ИмеетТип("Строка")
		.Заполнено()
		.Равно(Данные.Наименование);
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.ЗначениеРеквизита(Ссылка, "Поставщик"))
		.Равно(Данные.Поставщик);
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.ЗначениеРеквизита(Ссылка, "Наименование, Поставщик"))
		.Равно(Данные.Наименование);
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.ЗначениеРеквизита(ПредопределенноеЗначение("Справочник.Товары.ПустаяСсылка"), "Наименование"))
		.Равно(Неопределено);
	
КонецПроцедуры

Процедура ТаблицаСодержитЗаписи() Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Поставщик");
	Конструктор.Записать();
	ДанныеСправочника = Конструктор.ДанныеОбъекта();
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.ТаблицаСодержитЗаписи("Справочник.Товары")).ЭтоИстина();
	ЮТест.ОжидаетЧто(ЮТЗапросы.ТаблицаСодержитЗаписи("Справочник.МобильныеУстройства")).ЭтоЛожь();
	
	ЮТест.ОжидаетЧто(
		ЮТЗапросы.ТаблицаСодержитЗаписи("Справочник.Товары",
			ЮТест.Предикат()
				.Реквизит("Наименование").Равно(ДанныеСправочника.Наименование)))
		.ЭтоИстина();
	
	ЮТест.ОжидаетЧто(
		ЮТЗапросы.ТаблицаСодержитЗаписи("Справочник.Товары",
			ЮТест.Предикат()
				.Реквизит("Наименование").Равно(1)))
		.ЭтоЛожь();
	
КонецПроцедуры

Процедура РезультатЗапроса() Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Поставщик");
	Ссылка = Конструктор.Записать();
	ДанныеСправочника = Конструктор.ДанныеОбъекта();
	
	ОписаниеЗапроса = ЮТЗапросы.ОписаниеЗапроса();
	ОписаниеЗапроса.ИмяТаблицы = "Справочник.Товары";
	ОписаниеЗапроса.Условия.Добавить("Ссылка = &Ссылка");
	ОписаниеЗапроса.Условия.Добавить("НЕ ПометкаУдаления");
	ОписаниеЗапроса.ЗначенияПараметров.Вставить("Ссылка", Ссылка);
	ОписаниеЗапроса.ВыбираемыеПоля.Вставить("Наименование");
	ОписаниеЗапроса.ВыбираемыеПоля.Вставить("Число", "1+1");
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.РезультатЗапроса(ОписаниеЗапроса))
		.ИмеетДлину(1)
		.Свойство("[0].Наименование").Равно(ДанныеСправочника.Наименование)
		.Свойство("[0].Число").Равно(2);
	
КонецПроцедуры

Процедура РезультатПустой() Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Поставщик");
	Ссылка = Конструктор.Записать();
	ДанныеСправочника = Конструктор.ДанныеОбъекта();
	
	ОписаниеЗапроса = ЮТЗапросы.ОписаниеЗапроса();
	ОписаниеЗапроса.ИмяТаблицы = "Справочник.Товары";
	ОписаниеЗапроса.Условия.Добавить("Ссылка = &Ссылка");
	ОписаниеЗапроса.ЗначенияПараметров.Вставить("Ссылка", Ссылка);
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.РезультатПустой(ОписаниеЗапроса)).ЭтоЛожь();
	
	ОписаниеЗапроса.Условия.Добавить("ПометкаУдаления");
	ЮТест.ОжидаетЧто(ЮТЗапросы.РезультатПустой(ОписаниеЗапроса)).ЭтоИстина();
	
КонецПроцедуры

#КонецОбласти
