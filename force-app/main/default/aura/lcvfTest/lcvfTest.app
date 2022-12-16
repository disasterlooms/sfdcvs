<aura:application access="GLOBAL" extends="ltng:outApp"> 
 <aura:dependency resource="c:testa"/>
  <aura:attribute name="contact" type="Contact" 
               default="{ 'sobjectType': 'Contact' }"/>
<force:inputField aura:id="contactName" 
                 value="{!v.contact.Name}"/>  
</aura:application>