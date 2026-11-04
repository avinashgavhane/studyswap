<%@ Page Title="My Requests" Language="C#" MasterPageFile="~/Student/Student.Master"
    AutoEventWireup="true" CodeBehind="MyRequests.aspx.cs"
    Inherits="StudySwap.Student.MyRequests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
     /* ===== CONTAINER ===== */
/* ===== CONTAINER ===== */
.request-container {
    max-width: 1100px;
    margin: auto;
    padding: 3rem 1.5rem;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* ===== TITLE ===== */
.request-title {
    font-size: 2.8rem;
    font-weight: 900;
    text-align: center;
    margin-bottom: 3rem;
    letter-spacing: 1.2px;
    background: linear-gradient(90deg, #4f46e5, #9333ea, #ec4899);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    user-select: none;
}

/* ===== GRID ===== */
.request-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
    gap: 2.5rem;
}

/* ===== CARD ===== */
.request-card {
    background: rgba(255, 255, 255, 0.98);
    backdrop-filter: saturate(180%) blur(16px);
    border-radius: 24px;
    padding: 2rem 2.2rem;
    position: relative;
    overflow: hidden;
    box-shadow: 0 20px 40px rgba(0,0,0,0.15);
    transition: transform 0.4s ease, box-shadow 0.4s ease;
    cursor: pointer;
}

.request-card::before {
    content: "";
    position: absolute;
    inset: 0;
    padding: 3px;
    border-radius: 24px;
    background: linear-gradient(135deg, #6366f1, #8b5cf6, #ec4899);
    -webkit-mask:
        linear-gradient(#fff 0 0) content-box,
        linear-gradient(#fff 0 0);
    -webkit-mask-composite: xor;
    pointer-events: none;
    transition: background 0.4s ease;
}

.request-card:hover {
    transform: translateY(-12px) scale(1.05);
    box-shadow: 0 40px 90px rgba(99,102,241,0.45);
}

.request-card:hover::before {
    background: linear-gradient(135deg, #4338ca, #7c3aed, #db2777);
}

/* ===== TYPE BADGE ===== */
.badge-type {
    position: absolute;
    top: 18px;
    right: 18px;
    padding: 8px 20px;
    font-size: 0.8rem;
    font-weight: 800;
    letter-spacing: 1.2px;
    border-radius: 999px;
    color: #fff;
    text-transform: uppercase;
    user-select: none;
    box-shadow: 0 4px 6px rgb(0 0 0 / 0.2);
    transition: background 0.3s ease;
}

.buy {
    background: linear-gradient(135deg, #22c55e, #16a34a);
    box-shadow: 0 0 10px #22c55eaa;
}

.exchange {
    background: linear-gradient(135deg, #3b82f6, #2563eb);
    box-shadow: 0 0 10px #3b82f6aa;
}

/* ===== CONTENT ===== */
.request-card h5 {
    font-size: 1.3rem;
    font-weight: 900;
    margin-bottom: 1rem;
    color: #111827;
    letter-spacing: 0.05em;
    user-select: text;
}

.request-info {
    font-size: 1rem;
    color: #4b5563;
    margin-bottom: 0.5rem;
    line-height: 1.4;
    user-select: text;
}

/* ===== STATUS ===== */
.status {
    margin-top: 1.6rem;
    font-weight: 900;
    padding: 10px 22px;
    display: inline-block;
    border-radius: 999px;
    font-size: 0.85rem;
    letter-spacing: 0.7px;
    text-transform: uppercase;
    user-select: none;
    box-shadow: 0 4px 8px rgb(0 0 0 / 0.15);
    transition: background-color 0.3s ease, color 0.3s ease;
}

/* Status Colors */
.pending {
    background: linear-gradient(135deg, #facc15, #f59e0b);
    color: #1f2937;
    animation: pulse 2.5s infinite;
    box-shadow: 0 0 15px 3px rgba(250, 204, 21, 0.7);
}

.paid {
    background: linear-gradient(135deg, #22c55e, #16a34a);
    color: #fff;
    box-shadow: 0 0 15px 3px rgba(34, 197, 94, 0.7);
}

.rejected {
    background: linear-gradient(135deg, #ef4444, #b91c1c);
    color: #fff;
    box-shadow: 0 0 15px 3px rgba(239, 68, 68, 0.7);
}

/* pulse animation */
@keyframes pulse {
    0% {
        box-shadow: 0 0 0 0 rgba(250, 204, 21, 0.6);
    }
    70% {
        box-shadow: 0 0 0 14px rgba(250, 204, 21, 0);
    }
    100% {
        box-shadow: 0 0 0 0 rgba(250, 204, 21, 0);
    }
}

/* ===== EMPTY ===== */
.empty-msg {
    text-align: center;
    font-size: 1.5rem;
    font-weight: 700;
    color: #6b7280;
    margin-top: 5rem;
    user-select: none;
}

/* ===== MOBILE ===== */
@media (max-width: 640px) {
    .request-title {
        font-size: 2rem;
    }
    
    .request-card {
        padding: 1.6rem 1.8rem;
    }
    
    .request-card h5 {
        font-size: 1.1rem;
    }
    
    .request-info {
        font-size: 0.9rem;
    }
    
    .badge-type {
        padding: 6px 14px;
        font-size: 0.7rem;
    }
    
    .status {
        padding: 8px 18px;
        font-size: 0.75rem;
    }
}

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

 <div class="request-container">

    <div class="request-title">My Requests</div>

    <div class="request-grid">
    <asp:Repeater ID="rptRequests" runat="server">
    <HeaderTemplate>
        <div class="request-grid">
    </HeaderTemplate>

    <ItemTemplate>
        <div class="request-card">
            <span class='badge-type <%# Eval("RequestType").ToString().ToLower() %>'>
                <%# Eval("RequestType") %>
            </span>

            <h5><%# Eval("Title") %></h5>

            <div class="request-info">
                <strong>Requested On:</strong>
                <%# Convert.ToDateTime(Eval("RequestDate")).ToString("dd MMM yyyy") %>
            </div>

            <div class="request-info">
                <strong>Price:</strong>
                ₹<%# Eval("SellingPrice") %>
            </div>

            <span class='status <%# Eval("Status").ToString().ToLower() %>'>
                <%# Eval("Status") %>
            </span>
        </div>
    </ItemTemplate>

    <FooterTemplate>
        </div> <!-- close request-grid -->
    </FooterTemplate>
</asp:Repeater>

    </div>

    <asp:Label ID="lblEmpty" runat="server"
        CssClass="empty-msg"
        Text="You have not made any requests yet."
        Visible="false" />

</div>


</asp:Content>