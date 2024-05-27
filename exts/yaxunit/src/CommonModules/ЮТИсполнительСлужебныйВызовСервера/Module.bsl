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

// Выполняет тесты наборов модуля. Возвращает результат прогона
// Это обертка для прогона на сервере
// 
// Параметры:
//  ИдентификаторыТестовыхНаборов - Массив из Строка 
//  ИдентификаторТестовогоМодуля - Строка
// 
// Возвращаемое значение:
//  Массив из см. ЮТФабрикаСлужебный.ОписаниеИсполняемогоНабораТестов - Результат прогона наборов тестов, структура набора см. ЮТФабрикаСлужебный.ОписаниеИсполняемогоНабораТестов
Функция ВыполнитьГруппуНаборовТестов(Знач ИдентификаторыТестовыхНаборов, Знач ИдентификаторТестовогоМодуля) Экспорт
	
	Хранилище = ЮТИсполнительСлужебныйСервер.СерверноеХранилищеТестов();
	
	ТестовыйМодуль = Хранилище[ИдентификаторТестовогоМодуля];
	Наборы = Новый Массив();
	
	Для Каждого Идентификатор Из ИдентификаторыТестовыхНаборов Цикл
		Наборы.Добавить(Хранилище[Идентификатор]);
	КонецЦикла;
	
	Возврат ЮТИсполнительСлужебныйКлиентСервер.ВыполнитьГруппуНаборовТестов(Наборы, ТестовыйМодуль);
	
КонецФункции

// Сохранить информацию о тестовых сценариях.
// 
// Параметры:
//  ТестовыеМодули - Массив из см. ЮТФабрикаСлужебный.ОписаниеИсполняемогоТестовогоМодуля
Процедура СохранитьИнформациюОТестовыхСценариях(Знач ТестовыеМодули) Экспорт
	
	ЮТИсполнительСлужебныйСервер.СохранитьИнформациюОТестовыхСценариях(ТестовыеМодули);
	
КонецПроцедуры

#КонецОбласти
