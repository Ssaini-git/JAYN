import { LightningElement, track, wire, api } from 'lwc';
import ValidateUserCred from '@salesforce/apex/CreateDynamicFields.ValidateUserCred'; 
export default class LogInPage extends LightningElement {
    @track username;
    @track password;
    @track isLoad = false;
    
    handleChangeUsername(event){
            this.username = event.target.value;
        }
        handleChangepassword(event){
            this.password = event.target.value;
        }
    
    checkCredintial(){
       // alert(this.username);
       this.isLoad = true;
        ValidateUserCred({email:this.username, password:this.password})
        .then(result => {
            //alert(JSON.stringify(result));
            if(result == true){
                this.isLoad = false; 
            var selectEvent = new CustomEvent('myevent', {detail:{isValid : true}});
            this.dispatchEvent(selectEvent);
            }else{
                //alert('elseinside');
                this.isLoad = false; 
                var selectEvent = new CustomEvent('myevent', {detail:{isValid : false}});
            this.dispatchEvent(selectEvent);
            }

        })
    }
}