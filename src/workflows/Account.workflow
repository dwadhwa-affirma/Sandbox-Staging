<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NA_Opt_Out_Clear_Date</fullName>
        <description>Resets/clears the member&apos;s needs assessment opt out date</description>
        <field>NA_Opt_Out_Date__c</field>
        <formula>Today()</formula>
        <name>NA Opt Out Clear Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NA_Opt_Out_Set_Date</fullName>
        <description>The future date (1 year) set when a member chooses to &quot;opt out&quot;</description>
        <field>NA_Opt_Out_Date__c</field>
        <formula>TODAY() + 365</formula>
        <name>NA Opt Out Set Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NA Opt In</fullName>
        <actions>
            <name>NA_Opt_Out_Clear_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.NA_Opt_Out__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.NA_Opt_Out_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Needs Assessment member opt back in</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA Opt Out</fullName>
        <actions>
            <name>NA_Opt_Out_Set_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.NA_Opt_Out__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Needs Assessment member opt out for a period of 1 year</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
