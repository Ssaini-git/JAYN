import { LightningElement, track, wire,api } from 'lwc';
import ValidateUserCred from '@salesforce/apex/CreateDynamicFields.ValidateUserCred';  
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CustomerCityMain extends LightningElement {
    @track isLogin = true;
    @track isReport = false;
    @api objectApiName;
    @api recordId;
    handleEventListner(event){
        if(event.detail.isValid){
          this.isLogin = false;
          this.isReport = true;
        }
        else{
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Invalid username and password',
                variant: 'error',
            });
            this.dispatchEvent(event);
        
        }
    } 

   
}