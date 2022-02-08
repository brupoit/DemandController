trigger CasosTrigger on Case (before insert, before update, after update) {  
    if(trigger.isBefore){             
        if(Trigger.isUpdate){
        	CasosTriggerHandler.verificaNumeroProjetos(Trigger.new, Trigger.oldMap , Trigger.NewMap);
            CasosTriggerHandler.apagaCampoDuvida(Trigger.new, Trigger.oldMap , Trigger.NewMap);
        }
    }
    if(trigger.isAfter){
        if(Trigger.isUpdate){
			CasosTriggerHandler.criaComentarioNoCaso(Trigger.new, Trigger.oldMap , Trigger.NewMap);            
        }        
    }
}