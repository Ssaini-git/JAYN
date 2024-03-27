import { LightningElement,api,track } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import syncDataSf from '@salesforce/apex/SyncDataFromSalesforceToCustomerCity.constructReqBody'

export default class streamingApiComponent extends LightningElement {
    subscription = {};
  
    @api objectname;
    connectedCallback() {
      //  alert(this.objectname);
        const channel = '/data/'+this.objectname+'ChangeEvent';
   
        subscribe(channel, -1, this.messageCallback)
            .then(response => {
                console.log('Subscribed to channel:', JSON.stringify(response.channel));
                this.subscription = response;
            }); 
        onError(error => {
            console.error('Received error ', error);
        });
    }
    messageCallback = function(response) {
      var syncJson={};
        try{

        console.log('Received event: ', JSON.stringify(response));
       var fields={};
       console.log('==>'+JSON.stringify(response.data.payload));
        for (let obj of Object.keys(response.data.payload)) {
           fields[obj]= response.data.payload[obj];
        }
      }
        catch(e){
        console.log(e)
        }
        let payload = {updates:[{
            table: response.data.payload.ChangeEventHeader.entityName,
            data: [fields]
          }]}; 
          syncJson['HealthReport__Object_Name__c'] = response.data.payload.ChangeEventHeader.entityName;
          syncJson['HealthReport__TransactionId__c'] = response.data.payload.ChangeEventHeader.transactionKey;
          syncJson['HealthReport__Created_Date_Time__c'] = response.data.payload.LastModifiedDate; 
          syncJson['HealthReport__changeType__c'] = response.data.payload.ChangeEventHeader.changeType;
          syncJson['HealthReport__RecordId__c'] = response.data.payload.ChangeEventHeader.recordIds[0]
          
        console.log(JSON.stringify(payload));
        console.log(JSON.stringify(syncJson));
        syncDataSf({jsonString:JSON.stringify(payload),SyncJson:syncJson})
        .then(resp =>{
       // alert('in');
        })
        .catch(err=>{
            alert('e',e);
        }) 
        
      
       // //this.sendPayloadCC(response);
       // alert('bjb'+response)
    };

  /*  disconnectedCallback() {
        unsubscribe(this.subscription, response => {
            console.log('Unsubscribed from channel:', JSON.stringify(response.channel));
        });
    } */
    sendPayloadCC(payload){
        alert(payload)
    //jsonObj = JSON.parse(payload);
    payload.forEach(elm => {
      console.log('==>',elm);  
    });
    }
}
