#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Движения.Остатки.Записывать = Истина;
	ДвиженияОснования = РегистрыНакопления.Остатки.ВыбратьПоРегистратору(ДокументОснование);
	Пока ДвиженияОснования.Следующий() Цикл
		Движение = Движения.Остатки.ДобавитьПриход();
		ЗаполнитьЗначенияСвойств(Движение, ДвиженияОснования);
		Движение.Количество = -Движение.Количество;
		Движение.Период = Дата; // Не уверен.		
	КонецЦикла;	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения,СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриходнаяНакладная") Тогда
		ДокументОснование = ДанныеЗаполнения;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти

#КонецЕсли
