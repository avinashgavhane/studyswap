<%@ Page Title="Choose Option" Language="C#" 
    MasterPageFile="~/Student/Student.Master"
    AutoEventWireup="true"
    CodeBehind="Selectoption.aspx.cs"
    Inherits="StudySwap.Student.Selectoption" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
         <h3 class="fw-bold mb-4 text-center">Choose Request Type</h3>
<div class="container mt-5">
    <div class="card shadow p-4">

   

        <!-- REQUEST TYPE -->
        <asp:RadioButtonList ID="rblRequestType" runat="server"
            RepeatDirection="Horizontal"
            AutoPostBack="true"
            OnSelectedIndexChanged="rblRequestType_SelectedIndexChanged"
            CssClass="mb-4 text-center">
            <asp:ListItem Text=" Buy " Value="Buy" Selected="True" />
            <asp:ListItem Text=" Exchange " Value="Exchange" />
        </asp:RadioButtonList>

        <!-- EXCHANGE PANEL -->
        <asp:Panel ID="pnlExchange" runat="server" Visible="false">

            <label class="fw-bold">Select your product to exchange</label>

            <asp:DropDownList ID="ddlMyListings" runat="server"
                CssClass="form-select mb-3" />

        </asp:Panel>

        <!-- MESSAGE -->
        <asp:Label ID="lblMsg" runat="server"
            CssClass="text-danger fw-bold d-block mb-3"
            Visible="false" />

        <!-- ACTION BUTTON -->
   

    </div>
    <br />
    <center>
         <div class="text-center">
            <asp:Button ID="btnContinue" runat="server"
                Text="Continue"
                CssClass="btn btn-primary btn-lg"
                OnClick="btnContinue_Click" />
        </div>
        </center>
</div>
    <style>
        /* ============================================
   SELECT OPTION PAGE - POWERFUL STYLING
   ============================================ */

/* Container & Card Styling */
.container.mt-5 {
    max-width: 700px;
    padding: 2rem 1rem;
}

.card.shadow {
    border: none;
    border-radius: 20px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    position: relative;
    overflow: hidden;
    animation: fadeInUp 0.6s ease-out;
}

.card.shadow::before {
    pointer-events: none;   /* ✅ allow clicks to pass through */
}

.card.shadow .p-4 {
    position: relative;
    z-index: 1;
    background: white;
    border-radius: 16px;
    margin: 8px;
}

/* Page Title */
.card h3.fw-bold {
    color: #2d3748;
    font-size: 2rem;
    letter-spacing: -0.5px;
    position: relative;
    display: inline-block;
    padding-bottom: 15px;
}

.card h3.fw-bold::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 80px;
    height: 4px;
    background: linear-gradient(90deg, #667eea, #764ba2);
    border-radius: 2px;
}

/* Radio Button List - Custom Styling */
#ContentPlaceHolder1_rblRequestType {
    display: flex;
    justify-content: center;
    gap: 2rem;
    padding: 2rem 0;
}

#ContentPlaceHolder1_rblRequestType input[type="radio"] {
    display: none;
}

#ContentPlaceHolder1_rblRequestType label {
    position: relative;
    padding: 1.5rem 3rem;
    background: linear-gradient(135deg, #f6f8fb 0%, #e9ecef 100%);
    border: 3px solid #e9ecef;
    border-radius: 15px;
    cursor: pointer;
    font-size: 1.2rem;
    font-weight: 600;
    color: #6c757d;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07);
    min-width: 150px;
    text-align: center;
}

#ContentPlaceHolder1_rblRequestType label::before {
    content: '';
    position: absolute;
    top: 10px;
    right: 10px;
    width: 24px;
    height: 24px;
    border: 2px solid #cbd5e0;
    border-radius: 50%;
    transition: all 0.3s ease;
}

#ContentPlaceHolder1_rblRequestType label::after {
    content: '';
    position: absolute;
    top: 16px;
    right: 16px;
    width: 12px;
    height: 12px;
    background: #667eea;
    border-radius: 50%;
    transform: scale(0);
    transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

#ContentPlaceHolder1_rblRequestType input[type="radio"]:checked + label {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border-color: #667eea;
    transform: translateY(-5px);
    box-shadow: 0 12px 24px rgba(102, 126, 234, 0.4);
}

#ContentPlaceHolder1_rblRequestType input[type="radio"]:checked + label::before {
    border-color: white;
}

#ContentPlaceHolder1_rblRequestType input[type="radio"]:checked + label::after {
    transform: scale(1);
    background: white;
}

#ContentPlaceHolder1_rblRequestType label:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
}

/* Exchange Panel Styling */
#ContentPlaceHolder1_pnlExchange {
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
    padding: 2rem;
    border-radius: 15px;
    border-left: 5px solid #667eea;
    animation: slideDown 0.4s ease-out;
    margin-bottom: 1.5rem;
}

#ContentPlaceHolder1_pnlExchange label {
    color: #2d3748;
    font-size: 1.1rem;
    margin-bottom: 1rem;
    display: block;
}

/* Dropdown Styling */
.form-select {
    border: 2px solid #e2e8f0;
    border-radius: 12px;
    padding: 0.875rem 1.25rem;
    font-size: 1rem;
    color: #2d3748;
    background-color: white;
    background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23667eea' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M2 5l6 6 6-6'/%3e%3c/svg%3e");
    background-repeat: no-repeat;
    background-position: right 1rem center;
    background-size: 16px 12px;
    transition: all 0.3s ease;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.form-select:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
    outline: none;
}

.form-select:hover {
    border-color: #667eea;
}

/* Message Label */
#ContentPlaceHolder1_lblMsg {
    background: linear-gradient(135deg, #fee 0%, #fdd 100%);
    border-left: 4px solid #e53e3e;
    padding: 1rem 1.5rem;
    border-radius: 10px;
    animation: shake 0.5s ease;
}

/* Continue Button */
.btn-primary.btn-lg {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    border-radius: 12px;
    padding: 1rem 3rem;
    font-size: 1.2rem;
    font-weight: 700;
    letter-spacing: 0.5px;
    text-transform: uppercase;
    box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
}

.btn-primary.btn-lg::before {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 0;
    height: 0;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.3);
    transform: translate(-50%, -50%);
    transition: width 0.6s, height 0.6s;
}

.btn-primary.btn-lg:hover::before {
    width: 300px;
    height: 300px;
}

.btn-primary.btn-lg:hover {
    transform: translateY(-3px);
    box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
}

.btn-primary.btn-lg:active {
    transform: translateY(-1px);
    box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
}

/* Animations */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes slideDown {
    from {
        opacity: 0;
        max-height: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        max-height: 500px;
        transform: translateY(0);
    }
}

@keyframes shake {
    0%, 100% { transform: translateX(0); }
    25% { transform: translateX(-10px); }
    75% { transform: translateX(10px); }
}

@keyframes rotate {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
}

/* Responsive Design */
@media (max-width: 768px) {
    #ContentPlaceHolder1_rblRequestType {
        flex-direction: column;
        gap: 1rem;
        align-items: stretch;
    }
    
    #ContentPlaceHolder1_rblRequestType label {
        min-width: auto;
    }
    
    .card h3.fw-bold {
        font-size: 1.5rem;
    }
    
    .btn-primary.btn-lg {
        padding: 0.875rem 2rem;
        font-size: 1rem;
    }
}

/* Loading State */
.btn-primary.btn-lg:disabled {
    background: linear-gradient(135deg, #cbd5e0 0%, #a0aec0 100%);
    cursor: not-allowed;
    box-shadow: none;
}
    </style>

</asp:Content>