#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Рассчитать(Команда)
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;		
	КонецЕсли;
	
	КвартирВПодъезде = КвартирНаЭтаже*ЭтажейВДоме;
	НомерПодъезда = Цел((НомерКвартиры-1)/КвартирВПодъезде);
	НомерКвартирыВПодъезде = (НомерКвартиры-1)%КвартирВПодъезде;
	Этаж = Цел(НомерКвартирыВПодъезде/КвартирНаЭтаже);
	Результат = СтрШаблон(НСтр("ru='Подъезд %1, Этаж %2'"), НомерПодъезда+1, Этаж+1);
	
	Модифицированность = Ложь; 
КонецПроцедуры
#КонецОбласти

