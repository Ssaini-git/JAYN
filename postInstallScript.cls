global class postInstallScript implements InstallHandler{
global static void onInstall(InstallContext context) {
    // Get the base URL for the organization
    String baseUrl = URL.getSalesforceBaseUrl().toExternalForm(); // craete a custom label

    // Redirect to the Visualforce page
    PageReference pageRef = new PageReference(baseUrl + '/apex/MyVisualforcePage');
    pageRef.setRedirect(true);
    /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new String[] {'shyam.2607saini@gmail.com'});
    mail.setSubject('Post Install Script');
    mail.setPlainTextBody('This message is to inform you that the post install script has been executed successfully.');
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});*/
}
}