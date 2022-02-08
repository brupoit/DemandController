import { LightningElement, track } from "lwc";

export default class TesteCadastros extends LightningElement {
    
    @track isModalOpen = false;
    
    cadPerfil=false;

    handleClickPerfil(){
        this.cadPerfil=true;
    }

    handleClose() {
        this.cadPerfil=false;
    }
    
}