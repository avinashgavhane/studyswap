<%@ Page Title="Replies to Purchase Request" Language="C#" MasterPageFile="~/Student/Student.Master" 
    AutoEventWireup="true" CodeBehind="PurchaseRepliesList.aspx.cs" Inherits="StudySwap.Student.PurchaseRepliesList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        /* ============================================================
           REPLIES TO PURCHASE REQUEST — POWERFUL UI
           ============================================================ */

        .replies-page {
            padding: 2rem 2.5rem;
            background: #f0f4f8;
            min-height: 100vh;
            font-family: 'Poppins', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* ===== PAGE HEADER ===== */
        .replies-header {
            position: relative;
            background: linear-gradient(135deg, #4f46e5 0%, #06b6d4 100%);
            color: #fff;
            padding: 2rem 2.25rem;
            border-radius: 20px;
            margin-bottom: 1.75rem;
            box-shadow: 0 15px 35px rgba(79, 70, 229, 0.3);
            overflow: hidden;
        }

        .replies-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
        }

        .replies-header::after {
            content: '';
            position: absolute;
            bottom: -60%;
            right: 15%;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.06);
            border-radius: 50%;
        }

        .replies-header-inner {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        .replies-header h3 {
            margin: 0 0 6px 0;
            font-weight: 700;
            font-size: 1.85rem;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .replies-header h3 .rh-icon {
            background: rgba(255, 255, 255, 0.2);
            width: 50px;
            height: 50px;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.35rem;
        }

        .replies-header p {
            margin: 0;
            opacity: 0.92;
            font-size: 0.95rem;
        }

        .replies-header .count-pill {
            background: rgba(255, 255, 255, 0.18);
            backdrop-filter: blur(10px);
            padding: 10px 20px;
            border-radius: 999px;
            font-size: 0.85rem;
            font-weight: 600;
            border: 1px solid rgba(255, 255, 255, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        /* ===== REPLY GRID ===== */
        .replies-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        /* ===== REPLY CARD ===== */
        .reply-card {
            position: relative;
            background: #fff;
            border-radius: 18px;
            padding: 1.75rem;
            box-shadow: 0 10px 30px rgba(50, 50, 93, 0.08);
            transition: transform 0.3s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.3s;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            height: 100%;
            border: 1px solid #eef2f7;
        }

        .reply-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
            background: linear-gradient(90deg, #4f46e5, #06b6d4);
        }

        .reply-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 22px 45px rgba(50, 50, 93, 0.15);
        }

        /* ===== CARD HEAD ===== */
        .rc-head {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 1.1rem;
        }

        .rc-thumb {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            background: linear-gradient(135deg, #4f46e5, #06b6d4);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1.35rem;
            flex-shrink: 0;
            box-shadow: 0 8px 18px rgba(79, 70, 229, 0.3);
        }

        .rc-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: #1e293b;
            margin: 0;
            line-height: 1.3;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        /* ===== INFO ROWS ===== */
        .rc-info {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 1.5rem;
            flex-grow: 1;
        }

        .rc-row {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.88rem;
            color: #475569;
            line-height: 1.4;
        }

        .rc-row .rc-icon {
            width: 30px;
            height: 30px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.78rem;
            flex-shrink: 0;
        }

        .rc-icon.price    { background: #d1fae5; color: #065f46; }
        .rc-icon.condition{ background: #fef3c7; color: #92400e; }
        .rc-icon.seller   { background: #dbeafe; color: #1e40af; }
        .rc-icon.email    { background: #ede9fe; color: #5b21b6; }
        .rc-icon.phone    { background: #fee2e2; color: #991b1b; }

        .rc-row .rc-label {
            font-size: 0.72rem;
            font-weight: 700;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            display: block;
        }

        .rc-row .rc-value {
            font-weight: 600;
            color: #1e293b;
            font-size: 0.9rem;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .rc-row .rc-value a {
            color: #4f46e5;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }

        .rc-row .rc-value a:hover {
            color: #4338ca;
            text-decoration: underline;
        }

        .rc-price-tag {
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff;
            padding: 3px 10px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.85rem;
            display: inline-block;
        }

        /* ===== ACTION BUTTON ===== */
        .rc-action-wrap {
            margin-top: auto;
        }

        .rc-action {
            width: 100% !important;
            padding: 12px 20px !important;
            border: none !important;
            border-radius: 12px !important;
            font-size: 0.9rem !important;
            font-weight: 700 !important;
            font-family: inherit !important;
            cursor: pointer !important;
            background: linear-gradient(135deg, #4f46e5, #06b6d4) !important;
            color: #fff !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 8px !important;
            transition: all 0.25s !important;
            box-shadow: 0 6px 15px rgba(79, 70, 229, 0.25) !important;
            text-decoration: none !important;
        }

        .rc-action:hover {
            transform: translateY(-2px) !important;
            box-shadow: 0 12px 25px rgba(79, 70, 229, 0.4) !important;
            color: #fff !important;
        }

        .rc-action::before {
            content: '\f06e';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            font-size: 0.85rem;
        }

        /* ===== EMPTY STATE ===== */
        .empty-state {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(50, 50, 93, 0.08);
            padding: 4rem 2rem;
            text-align: center;
            color: #94a3b8;
            margin-bottom: 1.5rem;
        }

        .empty-illustration {
            width: 110px;
            height: 110px;
            margin: 0 auto 1.5rem;
            border-radius: 50%;
            background: linear-gradient(135deg, #e0e7ff, #cffafe);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.75rem;
        }

        .empty-state h5 {
            color: #1e293b;
            font-weight: 700;
            font-size: 1.2rem;
            margin-bottom: 8px;
        }

        .empty-state p {
            font-size: 0.92rem;
            color: #64748b;
            margin: 0;
            max-width: 420px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.55;
        }

        /* ===== BACK BUTTON ===== */
        .back-wrap {
            margin-top: 1rem;
        }

        .back-btn {
            display: inline-flex !important;
            align-items: center !important;
            gap: 8px !important;
            padding: 12px 22px !important;
            border-radius: 12px !important;
            font-size: 0.9rem !important;
            font-weight: 600 !important;
            font-family: inherit !important;
            background: #fff !important;
            color: #475569 !important;
            border: 1.5px solid #e2e8f0 !important;
            text-decoration: none !important;
            transition: all 0.25s !important;
            cursor: pointer !important;
            box-shadow: 0 4px 12px rgba(0,0,0,0.04) !important;
        }

        .back-btn:hover {
            background: #f8fafc !important;
            border-color: #cbd5e1 !important;
            color: #1e293b !important;
            transform: translateX(-3px) !important;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08) !important;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .replies-page { padding: 1.25rem; }
            .replies-header { padding: 1.5rem; }
            .replies-header h3 { font-size: 1.4rem; }
            .replies-grid { grid-template-columns: 1fr; }
            .reply-card { padding: 1.4rem; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="replies-page">

        <!-- ===== PAGE HEADER ===== -->
        <div class="replies-header">
            <div class="replies-header-inner">
                <div>
                    <h3>
                        <span class="rh-icon"><i class="fas fa-reply-all"></i></span>
                        Replies to Your Purchase Request
                    </h3>
                    <p>Students who have the item you're looking for — reach out and grab the deal!</p>
                </div>
                <span class="count-pill">
                    <i class="fas fa-comments"></i>
                    <asp:Label ID="lblReplyCount" runat="server" Text="0"></asp:Label> replies
                </span>
            </div>
        </div>

        <!-- ===== EMPTY STATE ===== -->
        <asp:Panel ID="pnlNoReplies" runat="server" CssClass="empty-state" Visible="false">
            <div class="empty-illustration">📭</div>
            <h5>No replies yet</h5>
            <p>Nobody has responded to this purchase request yet. We'll notify you the moment someone does!</p>
        </asp:Panel>

        <!-- ===== REPLIES GRID ===== -->
        <div class="replies-grid">

            <asp:Repeater ID="rptReplies" runat="server" OnItemCommand="rptReplies_ItemCommand">
                <ItemTemplate>
                    <div class="reply-card">

                        <!-- Card head: icon + title -->
                        <div class="rc-head">
                            <div class="rc-thumb">
                                <i class="fas fa-box-open"></i>
                            </div>
                            <h4 class="rc-title"><%# Eval("Title") %></h4>
                        </div>

                        <!-- Info rows -->
                        <div class="rc-info">

                            <div class="rc-row">
                                <div class="rc-icon price"><i class="fas fa-rupee-sign"></i></div>
                                <div>
                                    <span class="rc-label">Price</span>
                                    <span class="rc-value">
                                        <span class="rc-price-tag">₹ <%# Eval("SellingPrice", "{0:N0}") %></span>
                                    </span>
                                </div>
                            </div>

                            <div class="rc-row">
                                <div class="rc-icon condition"><i class="fas fa-star-half-alt"></i></div>
                                <div>
                                    <span class="rc-label">Condition</span>
                                    <span class="rc-value"><%# Eval("Condition") %></span>
                                </div>
                            </div>

                            <div class="rc-row">
                                <div class="rc-icon seller"><i class="fas fa-user"></i></div>
                                <div>
                                    <span class="rc-label">Seller</span>
                                    <span class="rc-value"><%# Eval("FullName") %></span>
                                </div>
                            </div>

                            <div class="rc-row">
                                <div class="rc-icon email"><i class="fas fa-envelope"></i></div>
                                <div>
                                    <span class="rc-label">Email</span>
                                    <span class="rc-value">
                                        <a href="mailto:<%# Eval("Email") %>"><%# Eval("Email") %></a>
                                    </span>
                                </div>
                            </div>

                            <div class="rc-row">
                                <div class="rc-icon phone"><i class="fas fa-phone"></i></div>
                                <div>
                                    <span class="rc-label">Phone</span>
                                    <span class="rc-value"><%# Eval("Phone") %></span>
                                </div>
                            </div>

                        </div>

                        <!-- Action button -->
                        <div class="rc-action-wrap">
                            <asp:Button ID="btnViewDetails" runat="server"
                                Text="View Details"
                                CommandName="ViewDetails"
                                CommandArgument='<%# Eval("ListingID") %>'
                                CssClass="rc-action" />
                        </div>

                    </div>
                </ItemTemplate>
            </asp:Repeater>

        </div>

        <!-- ===== BACK BUTTON ===== -->
        <div class="back-wrap">
            <asp:Button ID="btnBack" runat="server"
                Text="← Back to Purchase Requests"
                CssClass="back-btn"
                OnClick="btnBack_Click" />
        </div>

    </div>

</asp:Content>