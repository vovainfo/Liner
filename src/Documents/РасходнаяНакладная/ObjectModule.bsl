
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
   
    Запрос = Новый Запрос;
    Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

    Запрос.Текст =
		"ВЫБРАТЬ
		|	РасходнаяНакладнаяСписокНоменклатуры.Номенклатура КАК Номенклатура,
		|	СУММА(РасходнаяНакладнаяСписокНоменклатуры.Количество) КАК Количество
		|ПОМЕСТИТЬ втНоменклатура
		|ИЗ
		|	Документ.РасходнаяНакладная.СписокНоменклатуры КАК РасходнаяНакладнаяСписокНоменклатуры
		|ГДЕ
		|	РасходнаяНакладнаяСписокНоменклатуры.Ссылка = &Ссылка
		|СГРУППИРОВАТЬ ПО
		|	РасходнаяНакладнаяСписокНоменклатуры.Номенклатура
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втНоменклатура.Номенклатура,
		|	втНоменклатура.Количество,
		|	&Период КАК Период,
		|	&Склад КАК Склад
		|ИЗ
		|	втНоменклатура КАК втНоменклатура";
		
    Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("Склад", Склад);
    Выборка = Запрос.Выполнить().Выбрать();
   
    Пока Выборка.Следующий() Цикл
        Движение = Движения.Остатки.ДобавитьРасход();
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
    КонецЦикла;

	Движения.Остатки.БлокироватьДляИзменения = Истина;
	Движения.Остатки.Записывать = Истина;
    Движения.Записать();

    Запрос.Текст =
	"ВЫБРАТЬ
	|	Остатки.Номенклатура КАК Номенклатура,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(Остатки.Номенклатура) КАК НоменклатураПредставление,
	|	-Остатки.КоличествоОстаток КАК Дефицит,
	|	Остатки.Номенклатура,
	|	Остатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.Остатки.Остатки(&МоментВремени, Номенклатура В
	|		(ВЫБРАТЬ
	|			втНоменклатура.Номенклатура КАК Номенклатура
	|		ИЗ
	|			втНоменклатура КАК втНоменклатура)
	|	И Склад = &Склад) КАК Остатки
	|ГДЕ
	|	Остатки.КоличествоОстаток < 0";
   
    Запрос.УстановитьПараметр("МоментВремени", Новый Граница(МоментВремени()));
	Запрос.УстановитьПараметр("Склад", Склад);
    РезультатЗапроса = Запрос.Выполнить();
   
    Если Не РезультатЗапроса.Пустой() Тогда
        Отказ = Истина;
        ВыборкаОшибки = РезультатЗапроса.Выбрать();
        Пока ВыборкаОшибки.Следующий() Цикл
            Сообщение = Новый СообщениеПользователю;
            Сообщение.Текст = СтрШаблон(НСтр("ru='Товара <%1> недостаточно в количестве <%2> шт.'"), 
											ВыборкаОшибки.НоменклатураПредставление, ВыборкаОшибки.Дефицит);
            Сообщение.Сообщить();
        КонецЦикла;
    КонецЕсли;
КонецПроцедуры
#КонецОбласти

#КонецЕсли
