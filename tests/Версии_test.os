#использовать "../src/core"
#Использовать asserts
#Использовать logos

Перем юТест;
Перем Лог;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт

	юТест = Тестирование;

	ИменаТестов = Новый Массив;

	ИменаТестов.Добавить("ТестДолжен_ПроверитьМаксимальная");
	ИменаТестов.Добавить("ТестДолжен_ПроверитьВДиапазоне");
	// ИменаТестов.Добавить("ТестДолжен_ПроверитьПарсингОпций");
	// ИменаТестов.Добавить("ТестДолжен_ПроверитьПарсингМассивовОпций");

	Возврат ИменаТестов;

КонецФункции

Процедура ТестДолжен_ПроверитьМаксимальная() Экспорт

	ТестовыеСлучаи = Новый Массив;
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 1.0.2", "*", "1.0.2"));
	
	/////////
	// Любой символ
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 1.0.2 1.0 2.0", "1.0.X", "1.0.2"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 1.0.2 1.0 2.0", "1.*", "1.0.2"));
	/////////
	// Тильда
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 1.0.2", "~1.0.2", "1.0.2"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 0.0.4 0.0.3", "~0.0.2", "0.0.4"));
	
	/////////
	// Каретка
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 1.2.2 0.0.2 2.0", "^1.x", "1.2.2"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 1.0.2 2.0", "^1.0.2", "1.0.2"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.3.1 1.2.2 0.0.2 2.0", "^1.2.x", "1.3.1"));
	// Каретка меньше 0
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 0.0.4 0.0.3", "^0.x", "0.0.4"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 0.0.4 0.0.3", "^0.0", "0.0.4"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 0.0.4 0.0.3", "^0.0.3", "0.0.4"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 1.0.2 0.0.2 2.0", "^0.0.x", "0.0.2"));
	
	/////////////////////
	//  Ограничение с 2-x сторон
	
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 1.0.2 1.0 2.0", ">=1.0.0, <2.0", "1.0.2"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 1.1.2 1.1 2.0", ">=1.0.0, 1.x", "1.1.2"));
	
	Для каждого Тест Из ТестовыеСлучаи Цикл
		Лог.Отладка("Проверяю тестовый случай: %1", СтрСоединить(Тест.ВерсииПроверки, ","));
		Лог.Отладка(" >> диапазоны теста: %1", СтрСоединить(Тест.Диапазон, ","));
		
		Диапазон = Версии.Сравнение();
	
		Для каждого ПроверяемыеДиапазоны Из Тест.Диапазон Цикл
			Диапазон.ДобавитьДиапазон(ПроверяемыеДиапазоны);
		КонецЦикла;

		ИтоговаяВерсия = Диапазон
						.ПроверяемыеВерсии(Тест.ВерсииПроверки)
						.Максимальная();

		Утверждения.ПроверитьРавенство(ИтоговаяВерсия.ВСтроку(), Тест.Результат[0], "Результат должен совпадать с ожиданиями.");

	КонецЦикла

КонецПроцедуры


Процедура ТестДолжен_ПроверитьВДиапазоне() Экспорт

	ТестовыеСлучаи = Новый Массив;
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0", "*", "Истина"));
	
	/////////
	// Любой символ
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.2", "1.0.X", "Истина"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.2", "1.*", "Истина"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.2 0.0.1", "1.0.X", "Истина Ложь"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("2.0.2 2.0", "1.*", "Ложь Ложь"));
	/////////
	// Тильда
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.2", "~1.0.2", "Истина"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("0.0.4", "~0.0.2", "Истина"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.2", "~1.0.2", "Истина"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("0.0.4", "~0.0.2", "Истина"));

	/////////
	// Каретка
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.2.2", "^1.x", "Истина"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.2", "^1.0.2", "Истина"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.3.1", "^1.2.x", "Истина"));
	// Каретка меньше 0
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("0.0.4", "^0.x", "Истина"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0", "^0.x", "Ложь"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("0.0.4", "^0.0", "Истина"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("0.0.4 1.0.3", "^0.0", "Истина Ложь"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0", "^0.0", "Ложь"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("0.0.4", "^0.0.3", "Истина"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("0.1.4", "^0.0.3", "Ложь"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("0.0.4 0.1.4", "^0.0.3", "Истина Ложь"));

	ТестовыеСлучаи.Добавить(ТестовыйСлучай("0.0.2", "^0.0.x", "Истина"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0", "^0.0.x", "Ложь"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 0.0.2", "^0.0.x", "Ложь Истина"));

	// /////////////////////
	// //  Ограничение с 2-x сторон
	
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.0.0 1.0.1 1.0.2", ">=1.0.0, <2.0", "Истина Истина Истина"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("1.1.2 1.1 2.0", ">=1.0.0, 1.x", "Истина Истина Ложь"));
	
	Для каждого Тест Из ТестовыеСлучаи Цикл
		
		Лог.Отладка("Проверяю тестовый случай: %1", СтрСоединить(Тест.ВерсииПроверки, ", "));
		Лог.Отладка(" >> диапазоны теста: %1", СтрСоединить(Тест.Диапазон, ", "));
	
		Диапазон = Версии.Сравнение();

		Для каждого ПроверяемыеДиапазоны Из Тест.Диапазон Цикл
			Диапазон.ДобавитьДиапазон(ПроверяемыеДиапазоны);
		КонецЦикла;

		Индекс = 0;
		Для каждого ВерсияПроверки Из Тест.ВерсииПроверки Цикл
	
			Проверена = Диапазон.ПроверяемаяВерсия(ВерсияПроверки, Истина)
								.ВДиапазоне();
					
			Утверждения.ПроверитьРавенство(Проверена, Булево(Тест.Результат[Индекс]), СтрШаблон("Результат должен совпадать с ожиданиями. Версия <%1>", ВерсияПроверки));
			Индекс = Индекс + 1;
		КонецЦикла

	КонецЦикла

КонецПроцедуры

Функция ТестовыйСлучай(Знач ВерсииПроверки, Знач Диапазон, Знач Результат)

	Тест = Новый Структура;
	Тест.Вставить("ВерсииПроверки", СтрРазделить(ВерсииПроверки, " "));
	Тест.Вставить("Диапазон", СтрРазделить(Диапазон, ","));
	Тест.Вставить("Результат", СтрРазделить(Результат, " "));

	Возврат Тест;
КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.lib.semver.range_versions");
//Лог.УстановитьУровень(УровниЛога.Отладка);