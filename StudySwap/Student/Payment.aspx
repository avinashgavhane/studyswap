<%@ Page Title="" Language="C#" MasterPageFile="~/Student/Student.Master"
    AutoEventWireup="true" CodeBehind="Payment.aspx.cs"
    Inherits="StudySwap.Student.Payment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="card shadow-lg p-4" style="max-width:500px;margin:auto;">
        
        <h4 class="text-center mb-3">Payment Summary</h4>

        <!-- Amount -->
        <asp:Label ID="lblAmount" runat="server"
            CssClass="fw-bold fs-3 text-success d-block text-center mb-4" />

        <!-- Payment Options -->
        <asp:RadioButtonList ID="rblPaymentMethod" runat="server"
            CssClass="list-group mb-3"
            RepeatLayout="Flow">
            
            <asp:ListItem Value="Card" Selected="True">
                💳 Credit / Debit Card
            </asp:ListItem>

            <asp:ListItem Value="UPI">
                📱 UPI (Google Pay / PhonePe / Paytm)
            </asp:ListItem>

            <asp:ListItem Value="COD">
                💵 Cash on Delivery
            </asp:ListItem>

        </asp:RadioButtonList>

        <!-- Message -->
        <asp:Label ID="lblMsg" runat="server"
            CssClass="text-danger d-block mb-2"
            Visible="false" />

        <!-- Pay Button -->
        <asp:Button ID="btnPayNow" runat="server"
            Text="Pay Now"
            CssClass="btn btn-success btn-lg w-100"
            OnClick="btnPayNow_Click" />

    </div>
    <style>
        /* ============================================
   PAYMENT PAGE - POWERFUL STYLING
   ============================================ */

/* Main Card Container */
.card.shadow-lg {
    border: none;
    border-radius: 25px;
    background: linear-gradient(145deg, #ffffff 0%, #f8f9fa 100%);
    position: relative;
    overflow: hidden;
    margin-top: 3rem !important;
    animation: cardEntrance 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15) !important;
}

.card.shadow-lg::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 6px;
    background: linear-gradient(90deg, #10b981, #059669, #047857);
    animation: shimmer 2s infinite;
}

.card.shadow-lg::after {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: radial-gradient(circle, rgba(16, 185, 129, 0.05) 0%, transparent 70%);
    animation: pulse 4s ease-in-out infinite;
}

/* Page Title */
.card h4.text-center {
    color: #1f2937;
    font-size: 2rem;
    font-weight: 800;
    letter-spacing: -0.5px;
    position: relative;
    z-index: 2;
    margin-bottom: 2rem !important;
    text-transform: uppercase;
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.card h4.text-center::after {
    content: '💰';
    display: block;
    font-size: 2.5rem;
    margin-top: 0.5rem;
    animation: bounce 2s infinite;
}

/* Amount Display */
#ContentPlaceHolder1_lblAmount {
    position: relative;
    z-index: 2;
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    font-size: 3rem !important;
    font-weight: 900 !important;
    text-shadow: 0 4px 8px rgba(16, 185, 129, 0.2);
    animation: amountPulse 2s ease-in-out infinite;
    padding: 1.5rem;
    border-radius: 15px;
    background-color: rgba(16, 185, 129, 0.05);
    border: 2px dashed #10b981;
    margin-bottom: 2rem !important;
}

#ContentPlaceHolder1_lblAmount::before {
    content: '₹';
    position: absolute;
    left: 50%;
    transform: translateX(-50%);
    top: -30px;
    font-size: 1.5rem;
    color: #10b981;
    font-weight: 700;
}

/* Payment Method Radio List */
#ContentPlaceHolder1_rblPaymentMethod {
    position: relative;
    z-index: 2;
    display: flex;
    flex-direction: column;
    gap: 1rem;
    margin-bottom: 2rem !important;
}

#ContentPlaceHolder1_rblPaymentMethod input[type="radio"] {
    display: none;
}

#ContentPlaceHolder1_rblPaymentMethod label {
    position: relative;
    padding: 1.5rem 1.5rem 1.5rem 4.5rem;
    background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
    border: 3px solid #e5e7eb;
    border-radius: 16px;
    cursor: pointer;
    font-size: 1.1rem;
    font-weight: 600;
    color: #374151;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    display: flex;
    align-items: center;
}

/* Radio Circle Indicator */
#ContentPlaceHolder1_rblPaymentMethod label::before {
    content: '';
    position: absolute;
    left: 1.5rem;
    top: 50%;
    transform: translateY(-50%);
    width: 28px;
    height: 28px;
    border: 3px solid #d1d5db;
    border-radius: 50%;
    transition: all 0.3s ease;
    background: white;
}

#ContentPlaceHolder1_rblPaymentMethod label::after {
    content: '';
    position: absolute;
    left: 1.875rem;
    top: 50%;
    transform: translateY(-50%) scale(0);
    width: 16px;
    height: 16px;
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    border-radius: 50%;
    transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
    box-shadow: 0 0 10px rgba(16, 185, 129, 0.5);
}

/* Hover State */
#ContentPlaceHolder1_rblPaymentMethod label:hover {
    transform: translateX(8px);
    border-color: #10b981;
    box-shadow: 0 8px 24px rgba(16, 185, 129, 0.2);
    background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
}

#ContentPlaceHolder1_rblPaymentMethod label:hover::before {
    border-color: #10b981;
    transform: translateY(-50%) scale(1.1);
}

/* Selected State */
#ContentPlaceHolder1_rblPaymentMethod input[type="radio"]:checked + label {
    background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
    border-color: #10b981;
    color: #065f46;
    transform: translateX(8px) scale(1.02);
    box-shadow: 0 12px 32px rgba(16, 185, 129, 0.3);
}

#ContentPlaceHolder1_rblPaymentMethod input[type="radio"]:checked + label::before {
    border-color: #10b981;
    background: #10b981;
}

#ContentPlaceHolder1_rblPaymentMethod input[type="radio"]:checked + label::after {
    transform: translateY(-50%) scale(1);
}

/* Icon Styling in Options */
#ContentPlaceHolder1_rblPaymentMethod label::first-line {
    font-size: 1.3rem;
}

/* Error Message */
#ContentPlaceHolder1_lblMsg {
    position: relative;
    z-index: 2;
    background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
    border-left: 5px solid #ef4444;
    border-radius: 12px;
    padding: 1rem 1.5rem;
    margin-bottom: 1.5rem !important;
    animation: shake 0.5s ease;
    box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2);
    font-weight: 600;
}

#ContentPlaceHolder1_lblMsg::before {
    content: '⚠️ ';
    font-size: 1.2rem;
    margin-right: 0.5rem;
}

/* Pay Now Button */
#ContentPlaceHolder1_btnPayNow {
    position: relative;
    z-index: 2;
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    border: none;
    border-radius: 16px;
    padding: 1.5rem 2rem;
    font-size: 1.4rem;
    font-weight: 800;
    letter-spacing: 1px;
    text-transform: uppercase;
    color: white;
    box-shadow: 0 12px 32px rgba(16, 185, 129, 0.4);
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    overflow: hidden;
    cursor: pointer;
}

#ContentPlaceHolder1_btnPayNow::before {
    content: '🔒 ';
    font-size: 1.2rem;
    margin-right: 0.5rem;
}

#ContentPlaceHolder1_btnPayNow::after {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 0;
    height: 0;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.4);
    transform: translate(-50%, -50%);
    transition: width 0.6s, height 0.6s;
}

#ContentPlaceHolder1_btnPayNow:hover {
    transform: translateY(-4px) scale(1.02);
    box-shadow: 0 20px 48px rgba(16, 185, 129, 0.5);
    background: linear-gradient(135deg, #059669 0%, #047857 100%);
}

#ContentPlaceHolder1_btnPayNow:hover::after {
    width: 400px;
    height: 400px;
}

#ContentPlaceHolder1_btnPayNow:active {
    transform: translateY(-2px) scale(1);
    box-shadow: 0 12px 32px rgba(16, 185, 129, 0.4);
}

/* Loading State */
#ContentPlaceHolder1_btnPayNow:disabled {
    background: linear-gradient(135deg, #9ca3af 0%, #6b7280 100%);
    cursor: not-allowed;
    box-shadow: none;
    transform: none;
}

#ContentPlaceHolder1_btnPayNow:disabled::before {
    content: '⏳ ';
}

/* Security Badge */
.card.shadow-lg .p-4::after {
    content: '🔐 Secure Payment';
    position: absolute;
    bottom: 1rem;
    left: 50%;
    transform: translateX(-50%);
    font-size: 0.85rem;
    color: #6b7280;
    font-weight: 600;
    z-index: 2;
    opacity: 0.7;
    padding-bottom: 1rem;
}

/* Animations */
@keyframes cardEntrance {
    from {
        opacity: 0;
        transform: translateY(50px) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

@keyframes shimmer {
    0%, 100% {
        background-position: -200% center;
    }
    50% {
        background-position: 200% center;
    }
}

@keyframes pulse {
    0%, 100% {
        opacity: 0.5;
        transform: scale(1);
    }
    50% {
        opacity: 0.8;
        transform: scale(1.05);
    }
}

@keyframes bounce {
    0%, 100% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(-10px);
    }
}

@keyframes amountPulse {
    0%, 100% {
        transform: scale(1);
    }
    50% {
        transform: scale(1.05);
    }
}

@keyframes shake {
    0%, 100% { transform: translateX(0); }
    25% { transform: translateX(-10px); }
    50% { transform: translateX(10px); }
    75% { transform: translateX(-5px); }
}

/* Responsive Design */
@media (max-width: 576px) {
    .card.shadow-lg {
        margin: 1rem !important;
        border-radius: 20px;
    }
    
    .card h4.text-center {
        font-size: 1.5rem;
    }
    
    #ContentPlaceHolder1_lblAmount {
        font-size: 2.5rem !important;
    }
    
    #ContentPlaceHolder1_rblPaymentMethod label {
        padding: 1.25rem 1rem 1.25rem 4rem;
        font-size: 1rem;
    }
    
    #ContentPlaceHolder1_btnPayNow {
        font-size: 1.2rem;
        padding: 1.25rem 1.5rem;
    }
}

/* Print Styles */
@media print {
    .card.shadow-lg::before,
    .card.shadow-lg::after,
    #ContentPlaceHolder1_btnPayNow {
        display: none;
    }
}

/* Additional Polish - Success Feedback */
.payment-success {
    animation: successPop 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

@keyframes successPop {
    0% {
        transform: scale(0.8);
        opacity: 0;
    }
    50% {
        transform: scale(1.1);
    }
    100% {
        transform: scale(1);
        opacity: 1;
    }
}

/* Accessibility Enhancements */
#ContentPlaceHolder1_rblPaymentMethod input[type="radio"]:focus + label {
    outline: 3px solid #10b981;
    outline-offset: 2px;
}

#ContentPlaceHolder1_btnPayNow:focus {
    outline: 3px solid #10b981;
    outline-offset: 4px;
}
    </style>
</asp:Content>