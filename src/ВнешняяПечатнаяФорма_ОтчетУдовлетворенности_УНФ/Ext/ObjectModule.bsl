
#Область СведенияОбОбработке

Функция СведенияОВнешнейОбработке()Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	МассивНазначений = Новый Массив;
	МассивНазначений.Добавить("Документ.АктВыполненныхРабот"); //Указываем документ к которому делаем внешнюю печ. форму
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма"); //может быть - ПечатнаяФорма, ЗаполнениеОбъекта, ДополнительныйОтчет, СозданиеСвязанныхОбъектов... 
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", "Шаблон внешней печатной формы"); //имя под которым обработка будет зарегестрирована в справочнике внешних обработок
	ПараметрыРегистрации.Вставить("БезопасныйРежим", ЛОЖЬ);
	ПараметрыРегистрации.Вставить("Версия", "1.0"); 
	ПараметрыРегистрации.Вставить("Информация", "Шаблон внешней печатной формы"); 
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд, "ОтчетУдовлетворенности", "Макет", "ВызовСерверногоМетода", Истина, "ПечатьMXL");
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции


Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка")); 
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	
	Возврат Команды;
	
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры

#КонецОбласти

Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Макет", "ОтчетУдовлетворенности", СформироватьПечатнуюФорму(МассивОбъектов[0]));
	
КонецПроцедуры

&НаСервере
Функция СформироватьПечатнуюФорму(СсылкаНаДокумент) Экспорт
	
	СтруктураПараметров = Новый Структура;
	
	ЗаполнитьСтруктуруПараметровШаблона(СсылкаНаДокумент, СтруктураПараметров);
	
	Макет = ПолучитьМакет("Макет");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
	ОбластьКомментарий = Макет.ПолучитьОбласть("Комментарий");
	ОбластьПодпись = Макет.ПолучитьОбласть("Подпись");
	
	ТабДок = Новый ТабличныйДокумент;
	
	ОбластьШапка.Параметры.Заполнить(СсылкаНаДокумент);
	
	ТабДок.Вывести(ОбластьШапка);
	
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	
	Для Каждого Строка из СсылкаНаДокумент.РаботыИУслуги Цикл
		
		ОбластьСтрокаТаблицы.Параметры.РаботыИУслуги = Строка.Номенклатура;
		ТабДок.Вывести(ОбластьСтрокаТаблицы);
	КонецЦикла;
	
	
	ОбластьКомментарий.Параметры.Срок = СсылкаНаДокумент.Дата+3*24*3600;
	
	ТабДок.Вывести(ОбластьКомментарий);
	
	ОбластьПодпись.Параметры.Заполнить(СсылкаНаДокумент);
	
	ТабДок.Вывести(ОбластьПодпись);
	
	Возврат ТабДок;
	
КонецФункции

Процедура ЗаполнитьСтруктуруПараметровШаблона(СсылкаНаОбъект, СтруктураПШ, ДатаДанных = Неопределено)
	
	СтруктураПШ.Вставить("ШаблонПараметра", "Шаблон текста");
	
	
КонецПроцедуры



