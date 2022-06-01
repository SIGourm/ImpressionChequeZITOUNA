report 50102 "Impression Cheque Zitouna"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    // Use an RDL layout.
    DefaultLayout = RDLC;

    // Specify the name of the file that the report will use for the layout.
    RDLCLayout = 'ImpressionChequeZitouna.rdl';



    dataset
    {
        dataitem("Payment Header"; "Payment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";


            column(No; "No.")
            {
                // Include the caption of the "No." field in the dataset of the report.
                IncludeCaption = true;

            }

            /*trigger OnAfterGetRecord()
            begin


            end;*/

            dataitem("Payment Line"; "Payment Line")
            {
                DataItemLink = "No." = field("No.");

                DataItemLinkReference = "Payment Header";


                column(No_; "No.")
                {
                    // Include the caption of the "No." field in the dataset of the report.
                    IncludeCaption = true;

                }
                column(Posting_Date; "Posting Date")
                {
                    // Include the caption of the "No." field in the dataset of the report.
                    IncludeCaption = true;

                }

                column(TOTCheque_gd; "TOTCheque_gd")
                {

                }
                column(Mnt1; "Mnt1")
                {

                }
                column(AutreNom; "AutreNom")
                {

                }
                column(CompanyInfo; "City")
                {

                }


                trigger OnAfterGetRecord()

                begin
                    IF Frs.GET("Account No.") THEN;
                    CompBank.RESET;

                    //Total des  RecGPaymentLine.Amount par n° chèque
                    RecGPaymentLine.RESET;
                    RecGPaymentLine.SETRANGE(RecGPaymentLine."No.", "Payment Header"."No.");
                    //RecGPaymentLine.SETRANGE(RecGPaymentLine."N° chèque", "Payment Line"."N° chèque");
                    IF RecGPaymentLine.FINDSET THEN
                        TOTCheque_gd := 0;
                    REPEAT
                        TOTCheque_gd += RecGPaymentLine.Amount;
                    UNTIL RecGPaymentLine.NEXT = 0;


                    MntTTlettre := '';
                    //Convert."Montant en texte sans millimes"(MntTTlettre, ABS(TOTCheque_gd));
                    Mnt1 := '                           ' + MntTTlettre;
                    IF AutreNom = '' THEN
                        AutreNom := Frs.Name;

                end;



            }
            trigger OnAfterGetRecord()
            begin
                CompanyInfo.GET;

                IF "Payment Header"."Currency Code" = '' THEN
                    Devise := 'EUR'
                ELSE
                    Devise := "Currency Code";
                City := "Bank City";
                TxtBranchNo := "Bank Branch No.";
                TxtAcencyCode := COPYSTR("Agency Code", 3, 3);
                "TxtAccount_No" := "Bank Account No.";
                RIB := FORMAT("RIB Key");
                IF STRLEN(RIB) < 2 THEN
                    RIB := '0' + RIB;

                BankInfo := "Bank Name" + ' ' + "Payment Header"."Bank Name 2" + ' ' + "Bank Address" + ' ' + "Bank Address 2" + ' ' + "Bank City";
            end;
        }


    }



    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    // ApplicationArea = All;

                    //}
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }



    var



        RecGPaymentLine: Record "Payment Line";
        frs: Record Vendor;
        Bank: Record "Vendor Bank Account";
        CompanyInfo: Record "Company Information";
        CompBank: Record "Bank Account";


        BankInfo: Text[250];
        RIB: Text[30];
        TxtBranchNo: Text[30];
        TxtAcencyCode: Text[30];
        TxtAccount_No: Text[30];
        City: Text[30];
        MntTTlettre: Text[250];
        Mnt1: Text[250];
        AutreNom: Text[80];


        TOTCheque_gd: Decimal;

        Devise: Code[10];

}