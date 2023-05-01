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

///////////////////////////////////////////////////////////////////
// Содержит методы по работе с файлами
///////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Проверяет существование файла
// 
// Параметры:
//  ПутьКФайлу - Строка
//  Обработчик - ОписаниеОповещения - Обработчик асинхронного получения свойства файла. Если обработчик указан, но проверка выполняется асинхронно.
//             - Неопределено - Проверка выполняется синхронно.
// 
// Возвращаемое значение:
//  Булево - Существует
Функция Существует(ПутьКФайлу, Обработчик = Неопределено) Экспорт
	
	Файл = Новый Файл(ПутьКФайлу);
	
#Если Клиент Тогда
	Если Обработчик = Неопределено Тогда
		Возврат Файл.Существует();
	Иначе
		Файл.НачатьПроверкуСуществования(Обработчик);
	КонецЕсли;
#Иначе
	Возврат Файл.Существует();
#КонецЕсли
	
КонецФункции

// Проверяет, что по указанному пути находится каталог
// 
// Параметры:
//  ПутьКФайлу - Строка
//  Обработчик - ОписаниеОповещения - Обработчик асинхронного получения свойства файла. Если обработчик указан, но проверка выполняется асинхронно.
//             - Неопределено - Проверка выполняется синхронно.
// 
// Возвращаемое значение:
//  Булево - Это каталог
Функция ЭтоКаталог(ПутьКФайлу, Обработчик = Неопределено) Экспорт
	
	Файл = Новый Файл(ПутьКФайлу);
	
#Если Клиент Тогда
	Если Обработчик = Неопределено Тогда
		Возврат Файл.ЭтоКаталог();
	Иначе
		Файл.НачатьПроверкуЭтоКаталог(Обработчик);
	КонецЕсли;
#Иначе
	Возврат Файл.ЭтоКаталог();
#КонецЕсли
	
КонецФункции

#КонецОбласти
