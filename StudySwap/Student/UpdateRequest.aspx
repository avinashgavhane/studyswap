<%@ Page Title="" Language="C#" MasterPageFile="~/Student/Student.Master" AutoEventWireup="true" CodeBehind="UpdateRequest.aspx.cs" Inherits="StudySwap.Student.UpdateRequest" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container mt-4">
    <div class="card shadow p-4">

        <h3 class="fw-bold mb-3">Request Details</h3>

        <!-- REQUESTER INFO -->
        <h5 class="text-primary">Requester Details</h5>
        <p><strong>Name:</strong> <asp:Label ID="lblStudentName" runat="server" /></p>
        <p><strong>Email:</strong> <asp:Label ID="lblStudentEmail" runat="server" /></p>
        <p><strong>Mobile:</strong> <asp:Label ID="lblmobile" runat="server" /></p>

        <hr />

        <!-- REQUESTED PRODUCT -->
        <h5 class="text-success">Requested Product</h5>
        <p><strong>Title:</strong> <asp:Label ID="lblReqTitle" runat="server" /></p>
        <p><strong>Price:</strong> <asp:Label ID="lblReqPrice" runat="server" /></p>

        <hr />

        <!-- EXCHANGE PRODUCT -->
   <asp:Panel ID="pnlExchange" runat="server" Visible="false">

    <h5 class="fw-bold mt-4">Exchange Product</h5>

    <div id="exchangeCarousel" class="carousel slide mt-3" data-bs-ride="carousel">

        <!-- Indicators -->
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#exchangeCarousel" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#exchangeCarousel" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#exchangeCarousel" data-bs-slide-to="2"></button>
        </div>

        <!-- Slides -->
        <div class="carousel-inner rounded shadow">

            <div class="carousel-item active">
                <asp:Image ID="exImg1" runat="server" CssClass="d-block w-100 slider-img" />
            </div>

            <div class="carousel-item">
                <asp:Image ID="exImg2" runat="server" CssClass="d-block w-100 slider-img" />
            </div>

            <div class="carousel-item">
                <asp:Image ID="exImg3" runat="server" CssClass="d-block w-100 slider-img" />
            </div>

        </div>

        <!-- Controls -->
        <button class="carousel-control-prev" type="button" data-bs-target="#exchangeCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>

        <button class="carousel-control-next" type="button" data-bs-target="#exchangeCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>

    </div>

    <div class="mt-2">
        <asp:Label ID="lblExTitle" runat="server" CssClass="fw-bold d-block" />
        <asp:Label ID="lblExPrice" runat="server" />
    </div>

</asp:Panel>



        <!-- ACTION BUTTONS -->
        <div class="mt-4">
            <asp:Button ID="btnApprove" runat="server"
                Text="Approve"
                CssClass="btn btn-success me-2"
                OnClick="btnApprove_Click" />

            <asp:Button ID="btnReject" runat="server"
                Text="Reject"
                CssClass="btn btn-danger"
                OnClick="btnReject_Click" />
        </div>

        <asp:Label ID="lblMsg" runat="server"
            CssClass="fw-bold d-block mt-3"
            Visible="false" />

    </div>
</div>
    <style>
        /* ========================================
   POWERFUL CSS FOR UPDATE REQUEST PAGE
   Modern Design with Glassmorphism & Animations
   ======================================== */

/* === CONTAINER & LAYOUT === */
.container {
    max-width: 1200px;
    padding: 2rem 1rem;
}

/* === CARD STYLING WITH GLASSMORPHISM === */
.card {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    border-radius: 20px;
    position: relative;
    overflow: hidden;
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    z-index: 1;
}

.card > * {
    position: relative;
    z-index: 2;
}

.card:hover {
    transform: translateY(-5px);
    box-shadow: 0 20px 60px rgba(102, 126, 234, 0.4) !important;
}

/* === HEADINGS === */
.card h3 {
    color: #2d3748;
    font-size: 2rem;
    font-weight: 800;
    margin-bottom: 2rem;
    position: relative;
    display: inline-block;
}

.card h3::after {
    content: '';
    position: absolute;
    bottom: -8px;
    left: 0;
    width: 60%;
    height: 4px;
    background: linear-gradient(90deg, #667eea, #764ba2);
    border-radius: 2px;
    animation: expandWidth 0.6s ease-out;
}

@keyframes expandWidth {
    from { width: 0; }
    to { width: 60%; }
}

.card h5 {
    font-weight: 700;
    font-size: 1.3rem;
    margin: 1.5rem 0 1rem;
    padding-left: 15px;
    border-left: 4px solid;
    transition: all 0.3s ease;
}

.card h5:hover {
    padding-left: 25px;
}

.text-primary {
    color: #667eea !important;
    border-left-color: #667eea !important;
}

.text-success {
    color: #48bb78 !important;
    border-left-color: #48bb78 !important;
}

.text-warning {
    color: #ed8936 !important;
    border-left-color: #ed8936 !important;
}

/* === PARAGRAPH & LABELS === */
.card p {
    font-size: 1.05rem;
    color: #4a5568;
    margin-bottom: 0.8rem;
    line-height: 1.8;
    transition: all 0.2s ease;
}

.card p:hover {
    color: #2d3748;
    padding-left: 5px;
}

.card p strong {
    color: #2d3748;
    font-weight: 600;
    display: inline-block;
    min-width: 120px;
}

/* === HORIZONTAL RULE === */
.card hr {
    margin: 2rem 0;
    border: none;
    height: 2px;
    background: linear-gradient(
        90deg,
        transparent,
        rgba(102, 126, 234, 0.3) 50%,
        transparent
    );
    opacity: 0.6;
}

/* === IMAGE GALLERY === */
.row.mt-3 {
    margin-top: 2rem !important;
}

.img-fluid {
    width: 100%;
    height: 250px;
    object-fit: cover;
    border-radius: 15px;
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    cursor: pointer;
}

.img-fluid:hover {
    transform: scale(1.05) translateY(-10px);
    box-shadow: 0 20px 50px rgba(102, 126, 234, 0.3);
    z-index: 10;
}

/* === BUTTONS === */
.btn {
    padding: 12px 35px;
    font-size: 1.05rem;
    font-weight: 600;
    border-radius: 50px;
    border: none;
    text-transform: uppercase;
    letter-spacing: 1px;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.btn::before {
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

.btn:hover::before {
    width: 300px;
    height: 300px;
}

.btn-success {
    background: linear-gradient(135deg, #48bb78, #38a169);
    color: white;
}

.btn-success:hover {
    background: linear-gradient(135deg, #38a169, #2f855a);
    transform: translateY(-3px);
    box-shadow: 0 8px 25px rgba(72, 187, 120, 0.4);
}

.btn-danger {
    background: linear-gradient(135deg, #f56565, #e53e3e);
    color: white;
}

.btn-danger:hover {
    background: linear-gradient(135deg, #e53e3e, #c53030);
    transform: translateY(-3px);
    box-shadow: 0 8px 25px rgba(245, 101, 101, 0.4);
}

.btn:active {
    transform: translateY(-1px);
}

/* === MESSAGE LABEL === */
#ContentPlaceHolder1_lblMsg {
    padding: 15px 25px;
    border-radius: 12px;
    font-size: 1.1rem;
    text-align: center;
    animation: slideIn 0.5s ease-out;
    background: linear-gradient(135deg, #667eea15, #764ba215);
    border-left: 4px solid #667eea;
}

@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* === PANEL STYLING === */
#ContentPlaceHolder1_pnlExchange {
    background: linear-gradient(135deg, #fef5e7, #fdebd0);
    padding: 1.5rem;
    border-radius: 15px;
    margin: 1.5rem 0;
    border: 2px solid #ed8936;
    animation: fadeInUp 0.6s ease-out;
}

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* === RESPONSIVE DESIGN === */
@media (max-width: 768px) {
    .card h3 {
        font-size: 1.5rem;
    }
    
    .card h5 {
        font-size: 1.1rem;
    }
    
    .img-fluid {
        height: 200px;
        margin-bottom: 1rem;
    }
    
    .btn {
        width: 100%;
        margin-bottom: 10px;
    }
    
    .me-2 {
        margin-right: 0 !important;
    }
}

/* === UTILITY ENHANCEMENTS === */
.shadow {
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1), 
                0 5px 15px rgba(0, 0, 0, 0.07) !important;
}

.fw-bold {
    font-weight: 700 !important;
}

.mt-4 {
    margin-top: 2.5rem !important;
}

/* === LOADING ANIMATION === */
@keyframes pulse {
    0%, 100% {
        opacity: 1;
    }
    50% {
        opacity: 0.5;
    }
}

.card p:empty {
    animation: pulse 1.5s ease-in-out infinite;
    background: linear-gradient(90deg, #f0f0f0, #e0e0e0);
    border-radius: 4px;
    height: 20px;
    display: inline-block;
    width: 200px;
}

/* === SMOOTH SCROLLING === */
html {
    scroll-behavior: smooth;
}

/* === FOCUS STATES FOR ACCESSIBILITY === */
.btn:focus {
    outline: 3px solid rgba(102, 126, 234, 0.5);
    outline-offset: 3px;
}

/* === PRINT STYLES === */
@media print {
    .btn {
        display: none;
    }
    
    .card {
        box-shadow: none;
    }
}
/* === IMAGE SLIDER === */
.slider-img {
    height: 350px;
    object-fit: cover;
    border-radius: 20px;
    transition: transform 0.4s ease;
}

.carousel-inner {
    overflow: hidden;
}

.carousel-control-prev-icon,
.carousel-control-next-icon {
    filter: invert(1);
}

@media (max-width: 768px) {
    .slider-img {
        height: 220px;
    }
}

    </style>
</asp:Content>