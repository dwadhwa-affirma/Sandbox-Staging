<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Member_Email_Notification_CFCU</fullName>
        <description>Send Member Email Notification - CFCU</description>
        <protected>false</protected>
        <recipients>
            <field>Member_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@chevronfcu.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Secure_Portal_Notification_CFCU</template>
    </alerts>
    <alerts>
        <fullName>Send_Member_Email_Notification_CU_Case_CFCU</fullName>
        <description>Send Member Email Notification CU Case - CFCU</description>
        <protected>false</protected>
        <recipients>
            <field>Member_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@chevronfcu.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Secure_Portal_Notification_CU_Case_CFCU</template>
    </alerts>
    <alerts>
        <fullName>Send_Member_Email_Notification_CU_Case_Spectrum</fullName>
        <description>Send Member Email Notification CU Case - Spectrum</description>
        <protected>false</protected>
        <recipients>
            <field>Member_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@spectrumcu.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Secure_Portal_Notification_CUCase_Spctrm</template>
    </alerts>
    <alerts>
        <fullName>Send_Member_Email_Notification_CU_New_Case_Spectrum</fullName>
        <description>Send Member Email Notification CU New Case - Spectrum</description>
        <protected>false</protected>
        <recipients>
            <field>Member_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@spectrumcu.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Secure_Portal_Notif_CU_First_Spectrum</template>
    </alerts>
    <alerts>
        <fullName>Send_Member_Email_Notification_CU_Wires_Case_CFCU</fullName>
        <description>Send Member Email Notification CU Wires Case - CFCU</description>
        <protected>false</protected>
        <recipients>
            <field>Member_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@chevronfcu.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Secure_Portal_Notification_Wires_CFCU</template>
    </alerts>
    <alerts>
        <fullName>Send_Member_Email_Notification_CU_Wires_Case_Spectrum</fullName>
        <description>Send Member Email Notification CU Wires Case - Spectrum</description>
        <protected>false</protected>
        <recipients>
            <field>Member_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@spectrumcu.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Secure_Portal_Notification_Wires_Spctrm</template>
    </alerts>
    <alerts>
        <fullName>Send_Member_Email_Notification_New_Case_CFCU</fullName>
        <description>Send Member Email Notification New Case - CFCU</description>
        <protected>false</protected>
        <recipients>
            <field>Member_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@chevronfcu.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Secure_Portal_Notification_CU_First_CFCU</template>
    </alerts>
    <alerts>
        <fullName>Send_Member_Email_Notification_Spectrum</fullName>
        <description>Send Member Email Notification - Spectrum</description>
        <protected>false</protected>
        <recipients>
            <field>Member_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@spectrumcu.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Secure_Portal_Notification_Spectrum</template>
    </alerts>
    <fieldUpdates>
        <fullName>Secure_Portal_Comment_set_Member_Email</fullName>
        <description>This is used to retrieve the member&apos;s email address used when the portal case was created and store it in the Member Comment object. This is needed to allow future CU generated member comment notifications to be routed back to the member&apos;s email.</description>
        <field>Case_Creator_Email__c</field>
        <formula>Case__r.CreatedBy.Email</formula>
        <name>Secure Portal - Comment set Member Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Secure_Portal_Set_CU_Created_field</fullName>
        <field>CU_Created__c</field>
        <literalValue>1</literalValue>
        <name>Secure Portal - Set CU Created field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CU_Created</fullName>
        <description>Set the Portal member comment&apos;s field &quot;CU Created&quot; to true if the communication is from a Rep.  Used to filter unread member comments in the case roll up summary.</description>
        <field>CU_Created__c</field>
        <literalValue>1</literalValue>
        <name>Set CU Created</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Isread_field_on_Case</fullName>
        <field>IsMarkRead__c</field>
        <literalValue>0</literalValue>
        <name>Update Isread field on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>CU Case - New Chevron Case</fullName>
        <actions>
            <name>Send_Member_Email_Notification_New_Case_CFCU</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Created_by_Portal_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Communication_Origin__c</field>
            <operation>equals</operation>
            <value>CU</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Brand__c</field>
            <operation>equals</operation>
            <value>Chevron</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Category__c</field>
            <operation>notContain</operation>
            <value>Account Maintenance / Wires / Foreign - New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MemberCommentCount__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>Purpose of this workflow is to record the member&apos;s email address that created the portal case and send the member the notification email.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CU Case - New Chevron Comment</fullName>
        <actions>
            <name>Send_Member_Email_Notification_CU_Case_CFCU</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Created_by_Portal_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Communication_Origin__c</field>
            <operation>equals</operation>
            <value>CU</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Brand__c</field>
            <operation>equals</operation>
            <value>Chevron</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Category__c</field>
            <operation>notContain</operation>
            <value>Account Maintenance / Wires / Foreign - New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MemberCommentCount__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Purpose of this workflow is to record the member&apos;s email address that created the portal case and send the member the notification email.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CU Case - New Spectrum Case</fullName>
        <actions>
            <name>Send_Member_Email_Notification_CU_New_Case_Spectrum</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Created_by_Portal_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Communication_Origin__c</field>
            <operation>equals</operation>
            <value>CU</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Brand__c</field>
            <operation>equals</operation>
            <value>Spectrum</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Category__c</field>
            <operation>notContain</operation>
            <value>Account Maintenance / Wires / Foreign - New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MemberCommentCount__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>Purpose of this workflow is to send the Portal member the notification email.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CU Case - New Spectrum Comment</fullName>
        <actions>
            <name>Send_Member_Email_Notification_CU_Case_Spectrum</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Created_by_Portal_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Communication_Origin__c</field>
            <operation>equals</operation>
            <value>CU</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Brand__c</field>
            <operation>equals</operation>
            <value>Spectrum</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Category__c</field>
            <operation>notContain</operation>
            <value>Account Maintenance / Wires / Foreign - New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MemberCommentCount__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Purpose of this workflow is to send the Portal member the notification email.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CU Wires Case - New Chevron Comment</fullName>
        <actions>
            <name>Send_Member_Email_Notification_CU_Wires_Case_CFCU</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Created_by_Portal_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Communication_Origin__c</field>
            <operation>equals</operation>
            <value>CU</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Brand__c</field>
            <operation>equals</operation>
            <value>Chevron</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Category__c</field>
            <operation>contains</operation>
            <value>Account Maintenance / Wires / Foreign - New</value>
        </criteriaItems>
        <description>Purpose of this workflow is to send the Portal member the notification email of a CU initiated Wires case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CU Wires Case - New Spectrum Comment</fullName>
        <actions>
            <name>Send_Member_Email_Notification_CU_Wires_Case_Spectrum</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Created_by_Portal_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Communication_Origin__c</field>
            <operation>equals</operation>
            <value>CU</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Brand__c</field>
            <operation>equals</operation>
            <value>Spectrum</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Category__c</field>
            <operation>contains</operation>
            <value>Account Maintenance / Wires / Foreign - New</value>
        </criteriaItems>
        <description>Purpose of this workflow is to send the Portal member the notification email of a CU initiated Wires case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Creator Identification</fullName>
        <actions>
            <name>Set_CU_Created</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Member_Comment__c.Communication_Origin__c</field>
            <operation>equals</operation>
            <value>CU</value>
        </criteriaItems>
        <description>Indicator set by workflow to signify that the comment was created by a CU representative.  This is needed to filter the roll up summary count of unread member comments.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MBR Case - New Chevron Comment</fullName>
        <actions>
            <name>Send_Member_Email_Notification_CFCU</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Secure_Portal_Comment_set_Member_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Created_by_Portal_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Communication_Origin__c</field>
            <operation>equals</operation>
            <value>CU</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Brand__c</field>
            <operation>contains</operation>
            <value>Chevron</value>
        </criteriaItems>
        <description>Purpose of this workflow is to record the member&apos;s email address that created the portal case and send the member the notification email.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MBR Case - New Spectrum Comment</fullName>
        <actions>
            <name>Send_Member_Email_Notification_Spectrum</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Secure_Portal_Comment_set_Member_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Created_by_Portal_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Communication_Origin__c</field>
            <operation>equals</operation>
            <value>CU</value>
        </criteriaItems>
        <criteriaItems>
            <field>Member_Comment__c.Brand__c</field>
            <operation>equals</operation>
            <value>Spectrum</value>
        </criteriaItems>
        <description>Purpose of this workflow is to record the Portal member&apos;s email address that created the portal case and send the member the notification email.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Mark Case as unread</fullName>
        <actions>
            <name>Update_Isread_field_on_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Portal</description>
        <formula>AND  (NOT(ISBLANK( Member_Communication__c )), IsRead__c = false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Portal Set CU Created</fullName>
        <actions>
            <name>Secure_Portal_Set_CU_Created_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Member_Comment__c.Communication_Origin__c</field>
            <operation>equals</operation>
            <value>CU</value>
        </criteriaItems>
        <description>Set the Portal/member comment field &quot;CU Created&quot; to true if a CU rep has created the comment.  This is used to calculate the total number of unread comments initiated by the member.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
