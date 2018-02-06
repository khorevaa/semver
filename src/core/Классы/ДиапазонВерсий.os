#Использовать logos

Перем Лог;

Перем Сравнение; // Соответствие

Процедура ПриСозданииОбъекта(Знач ДиапазонСтрокой = "*")

	Сравнение =  Новый Соответствие;
	
	ПреобразоватьВСравнение(СокрЛП(ДиапазонСтрокой));

	ОптимизироватьСравнение();

КонецПроцедуры

// Выполняет проверку, что версия удовлетворяет диапазону
//
// Возвращаемое значение:
//   Булево - Истина / ложь 
Функция ПроверитьВерсию(Знач ПроверяемаяВерсия) Экспорт

	Результат = Ложь;

	Лог.Отладка("Количество выполняемых сравнений %1 ", Сравнение.Количество());

	Для каждого ЗнакВерсия Из Сравнение Цикл

		Результат = ВыполнитьСравнения(ПроверяемаяВерсия, ЗнакВерсия.Значение, ЗнакВерсия.Ключ);

		Если Не Результат Тогда
			Прервать;
		КонецЕсли;

	КонецЦикла;

	Возврат Результат;

КонецФункции

// Возвращает сравнение для диапазона версий
//
// Возвращаемое значение:
//   Соответствие 
//      ключ     - символ действия (>=. <=, =, >, <)
//      Значение - класс версия
Функция ПолучитьСравнение() Экспорт

	Возврат Сравнение;

КонецФункции

// Выполняет проверку массива версий, на соответствие диапазону
//
// Параметры:
//   МассивВерсий - элементы класса версия - Версия для сравнения с диапазоном
//
// Возвращаемое значение:
//   Массив - элементы класса версия
Функция ПроверитьВерсии(Знач МассивВерсий) Экспорт

	ИтоговыйМассив = Новый Массив;

	Для каждого ПроверяемаяВерсия Из МассивВерсий Цикл

		Если ПроверитьВерсию(ПроверяемаяВерсия) Тогда
			ИтоговыйМассив.Добавить(ПроверяемаяВерсия);
		КонецЕсли;

	КонецЦикла;

	Возврат ИтоговыйМассив;

КонецФункции

// Выполняет проверку массива версий, на соответствие диапазону
// И возвращает максимальную из них 
//
// Параметры:
//   МассивВерсий - элементы класса версия - Версия для сравнения с диапазоном
//
// Возвращаемое значение:
//   Версия - класс версия, максимальный из проверяемого массива
Функция МаксимальнаяВерсияИЗВерсий(Знач ПроверяемыйМассивВерсий) Экспорт

	ИтоговыйМассив = ПроверитьВерсии(ПроверяемыйМассивВерсий);
	Лог.Отладка("МаксимальнаяВерсияИЗВерсий >> версий в массиве: %1", ИтоговыйМассив.Количество());

	Возврат Версии.МаксимальнаяИзМассива(ИтоговыйМассив);

КонецФункции

// Возвращает строковое представление диапазона версий
//
// Возвращаемое значение:
//   строка - строковое представление (типа: >=1.0.0 - < 2.0.0)
Функция ВСтроку() Экспорт

	СтрокаДиапазона = "";
	МассивСравнения = Новый Массив;
	Для каждого ЗнакВерсия Из Сравнение Цикл
		МассивСравнения.Добавить(ЗнакВерсия.Ключ+ЗнакВерсия.Значение);
	КонецЦикла;

	Возврат СтрСоединить(МассивСравнения, " - ");

КонецФункции

// Объединяет с переданным диапазоном
//
// Параметры:
//   ВходящийДиапазон - класс ДиапазонВерсий - объединяемый диапазон
Процедура ОбъединитьСДиапазоном(Знач ВходящийДиапазон) Экспорт

	Для каждого КлючЗначение Из ВходящийДиапазон.ПолучитьСравнение() Цикл

		ДобавитьСравнение(КлючЗначение.Значение, КлючЗначение.Ключ);

	КонецЦикла;

	ОптимизироватьСравнение();

КонецПроцедуры

Функция ВыполнитьСравнения(ПроверяемаяВерсия, ВерсияСравнения, Знак)

	Лог.Отладка("Выполняю сравнение: %3 (%2) %1", ВерсияСравнения.ВСтроку(), Знак, ПроверяемаяВерсия.ВСтроку());

	Если Знак = "=" Тогда

		Возврат ПроверяемаяВерсия.Равны(ВерсияСравнения);

	ИначеЕсли Знак = ">=" Тогда

		Возврат ПроверяемаяВерсия.БольшеИлиРавны(ВерсияСравнения);

	ИначеЕсли Знак = ">" Тогда

		Возврат ПроверяемаяВерсия.Больше(ВерсияСравнения);

	ИначеЕсли Знак = "<=" Тогда

		Возврат ПроверяемаяВерсия.МеньшеИлиРавны(ВерсияСравнения);

	ИначеЕсли Знак = "<" Тогда

		Возврат ПроверяемаяВерсия.Меньше(ВерсияСравнения);

	КонецЕсли;

КонецФункции

Процедура ПреобразоватьВСравнение(Знач ДиапазонСтрокой)

	Лог.Отладка("Преобразовываю строку <%1> в диапазон", ДиапазонСтрокой);

	Если ДиапазонСтрокой = "*"
		ИЛИ ДиапазонСтрокой = "X"
		ИЛИ ДиапазонСтрокой = "x"
		ИЛИ ДиапазонСтрокой = "" Тогда
		ДобавитьСравнение(Новый Версия("0.0.0"), ">=");
		Возврат;
	КонецЕсли;

	НатуральныйДиапазон = Истина;

	Если СтрЗаканчиваетсяНа(ДиапазонСтрокой, ".x")
		ИЛИ СтрЗаканчиваетсяНа(ДиапазонСтрокой, ".X")
		ИЛИ СтрЗаканчиваетсяНа(ДиапазонСтрокой, ".*") Тогда
		ДиапазонСтрокой = Сред(ДиапазонСтрокой, 1, СтрДлина(ДиапазонСтрокой)-2);
		НатуральныйДиапазон = Ложь;
		Лог.Отладка("Установлен ненатуральный диапазон");
	КонецЕсли;

	Если СтрНачинаетсяС(ДиапазонСтрокой, "~")
		ИЛИ СтрНачинаетсяС(ДиапазонСтрокой, "^") Тогда
		ОбработатьДиапазонПоСимволу(ДиапазонСтрокой);
		Возврат;
	КонецЕсли;

	ТочекСлева = 0;

	МассивВерсии = СтрРазделить(ДиапазонСтрокой, ".");

	Если МассивВерсии.Количество() > 0  Тогда
		ТочекСлева = МассивВерсии.ВГраница();
	КонецЕсли;

	Лог.Отладка("Посчитали количество точек слева <%1> у строки <%2> ", ТочекСлева, ДиапазонСтрокой);

	Если НЕ НатуральныйДиапазон Тогда

		Если ТочекСлева = 1 Тогда

			ОбработатьДиапазонПоСимволу("~"+ДиапазонСтрокой);
			Возврат;

		ИначеЕсли ТочекСлева  = 0 Тогда

			ОбработатьДиапазонПоСимволу("^"+ДиапазонСтрокой);
			Возврат;

		КонецЕсли;

	КонецЕсли;

	Знак = "=";

	Если СтрНачинаетсяС(ДиапазонСтрокой, ">=")
		ИЛИ СтрНачинаетсяС(ДиапазонСтрокой, "<=") Тогда
		Знак = Сред(ДиапазонСтрокой, 1, 2);

	ИначеЕсли СтрНачинаетсяС(ДиапазонСтрокой, ">")
		ИЛИ СтрНачинаетсяС(ДиапазонСтрокой, "<")
		ИЛИ СтрНачинаетсяС(ДиапазонСтрокой, "=") Тогда

		Знак = Сред(ДиапазонСтрокой, 1, 1);

	КонецЕсли;

	ВерсияСравнения = Новый Версия(СтрЗаменить(ДиапазонСтрокой, Знак, ""));

	ДобавитьСравнение(ВерсияСравнения, Знак);

КонецПроцедуры

Процедура ОбработатьДиапазонПоСимволу(Знач ДиапазонСтрокой)

	Лог.Отладка("Обрабатываю символьный диапазон <%1>", ДиапазонСтрокой);

	СтрокаВерсии = Сред(ДиапазонСтрокой, 2);
	НачальнаяВерсия = Новый Версия(СтрокаВерсии);
	Если НачальнаяВерсия.Ошибка() Тогда
		Лог.КритичнаяОшибка(НачальнаяВерсия.ПолучитьОписаниеОшибки());
		ДобавитьСравнение(Новый Версия("0.0.0"), ">=");
		Возврат;
	КонецЕсли;

	НижняяВерсия = НачальнаяВерсия;
	ДобавитьСравнение(НижняяВерсия, ">=");

	ВерхняяВерсия = Новый Версия("0.0.0");

	Если СтрНачинаетсяС(СтрокаВерсии, "0.") Тогда

		ВерхняяВерсия.Основная = НижняяВерсия.Основная;
		ВерхняяВерсия.Второстепенная = НижняяВерсия.Второстепенная + 1;

	ИначеЕсли СтрНачинаетсяС(СтрокаВерсии, "0.0.") Тогда

		ВерхняяВерсия.Основная = НижняяВерсия.Основная;
		ВерхняяВерсия.Второстепенная = НижняяВерсия.Второстепенная;
		ВерхняяВерсия.Патч = НижняяВерсия.Патч + 1;

	ИначеЕсли СтрНачинаетсяС(ДиапазонСтрокой, "^")
		ИЛИ СтрНайти(СтрокаВерсии, ".") = 0  Тогда

		ВерхняяВерсия.Основная = НижняяВерсия.Основная + 1 ;

	ИначеЕсли СтрНачинаетсяС(ДиапазонСтрокой, "~")Тогда

		ВерхняяВерсия.Основная = НижняяВерсия.Основная;
		ВерхняяВерсия.Второстепенная = НижняяВерсия.Второстепенная + 1;

	КонецЕсли;

	ДобавитьСравнение(ВерхняяВерсия, "<");

КонецПроцедуры

Процедура ДобавитьСравнение(Знач ВерсияСравнения, Знач ЗнакСравнения)

	Лог.Отладка("Добавляю запись в сравнение: %1 знак: %2", ВерсияСравнения.ВСтроку(), ЗнакСравнения);

	ВерсияВСравнении = Сравнение.Получить(ЗнакСравнения);

	Если ВерсияВСравнении = Неопределено Тогда
		Сравнение.Вставить(ЗнакСравнения, ВерсияСравнения);
		Лог.Отладка("Добавлена новая запись: %1 знак: %2", ВерсияСравнения.ВСтроку(), ЗнакСравнения);
		Возврат;
	КонецЕсли;
	Лог.Отладка("Для знака <%2> уже есть версия <%1> в сравнение", ВерсияВСравнении.ВСтроку(), ЗнакСравнения);

	Если ЗнакСравнения = ">="
		ИЛИ ЗнакСравнения = ">" Тогда

		Если Версии.ВерсияБольше(ВерсияСравнения.ВСтроку(), ВерсияВСравнении.ВСтроку()) Тогда

			Сравнение.Вставить(ЗнакСравнения, ВерсияСравнения);
			Возврат;

		КонецЕсли;
	КонецЕсли;

	Если ЗнакСравнения = "<="
		ИЛИ ЗнакСравнения = "<" Тогда

		Если Версии.ВерсияМеньше(ВерсияСравнения.ВСтроку(), ВерсияВСравнении.ВСтроку()) Тогда

			Сравнение.Вставить(ЗнакСравнения, ВерсияСравнения);
			Возврат;

		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ОптимизироватьСравнение()

	ВерсияРавно = Сравнение["="];

	Если НЕ ВерсияРавно = Неопределено Тогда

		Сравнение = Новый Соответствие;
		Сравнение.Вставить("=", ВерсияРавно);
		Возврат;

	КонецЕсли;

	ВерсияБольше = Сравнение[">"];
	ВерсияБольшеРавно = Сравнение[">="];

	Если НЕ ВерсияБольше = Неопределено
		И Не ВерсияБольшеРавно = Неопределено Тогда

		Если ВерсияБольше.Меньше(ВерсияБольшеРавно) Тогда

			Сравнение.Удалить(">");
		Иначе

		КонецЕсли;

		Если ВерсияБольшеРавно.Меньше(ВерсияБольше) Тогда

			Сравнение.Удалить(">=");

		КонецЕсли;

	КонецЕсли;

	ВерсияМеньше = Сравнение["<"];
	ВерсияМеньшеРавно = Сравнение["<="];

	Если НЕ ВерсияМеньше = Неопределено
		И Не ВерсияМеньшеРавно = Неопределено Тогда

		Если ВерсияМеньше.Меньше(ВерсияМеньшеРавно) Тогда

			Сравнение.Удалить("<");

		КонецЕсли;

		Если ВерсияМеньшеРавно.Меньше(ВерсияМеньше) Тогда

			Сравнение.Удалить("<=");

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.lib.semver.range_versions");
