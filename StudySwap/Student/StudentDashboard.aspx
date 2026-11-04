<%@ Page Title="Student Dashboard" Language="C#" MasterPageFile="~/Student/Student.Master"
    AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="StudySwap.Student.StudentDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        .dashboard-container {
            padding: 2rem 2.5rem;
            background: #f0f4f8;
            min-height: 100vh;
            font-family: 'Poppins', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #34495e;
        }

        .dashboard-header {
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 15px;
        }

        .dashboard-header h1 {
            font-size: 2.2rem;
            font-weight: 700;
            color: #2c3e50;
            margin: 0 0 0.3rem 0;
        }

        .dashboard-header p {
            font-size: 1.05rem;
            color: #7f8c8d;
            margin: 0;
        }

        .header-actions { display: flex; gap: 10px; flex-wrap: wrap; }

        .btn-action {
            padding: 10px 20px;
            border: none;
            border-radius: 10px;
            font-size: 13.5px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            font-family: 'Poppins', sans-serif;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.25s;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
        }
        .btn-primary:hover {
            box-shadow: 0 8px 20px rgba(102,126,234,0.4);
            transform: translateY(-2px);
            color: #fff;
        }

        .btn-light {
            background: #fff;
            color: #475569;
            border: 1px solid #e2e8f0;
        }
        .btn-light:hover {
            background: #f8fafc;
            transform: translateY(-2px);
            color: #1e293b;
        }

        /* ===== STATS ===== */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }

        .stat-card {
            background: #fff;
            padding: 1.75rem;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(50,50,93,0.08), 0 6px 15px rgba(0,0,0,0.05);
            transition: transform 0.3s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.3s;
            position: relative;
            overflow: hidden;
            text-decoration: none;
            color: inherit;
            display: block;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }

        .stat-card.green::before { background: linear-gradient(90deg, #10b981, #059669); }
        .stat-card.orange::before { background: linear-gradient(90deg, #f59e0b, #f97316); }
        .stat-card.purple::before { background: linear-gradient(90deg, #8b5cf6, #7c3aed); }
        .stat-card.pink::before { background: linear-gradient(90deg, #ec4899, #db2777); }
        .stat-card.red::before { background: linear-gradient(90deg, #ef4444, #dc2626); }

        .stat-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 40px rgba(50,50,93,0.15);
            color: inherit;
        }

        .stat-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.75rem;
        }

        .stat-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            flex-shrink: 0;
        }

        .stat-icon.blue   { background: linear-gradient(135deg, #667eea, #764ba2); }
        .stat-icon.green  { background: linear-gradient(135deg, #10b981, #059669); }
        .stat-icon.orange { background: linear-gradient(135deg, #f59e0b, #f97316); }
        .stat-icon.purple { background: linear-gradient(135deg, #8b5cf6, #7c3aed); }
        .stat-icon.pink   { background: linear-gradient(135deg, #ec4899, #db2777); }
        .stat-icon.red    { background: linear-gradient(135deg, #ef4444, #dc2626); }

        .stat-value {
            font-size: 2.2rem;
            font-weight: 800;
            color: #1e293b;
            line-height: 1;
        }

        .stat-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-top: 4px;
        }

        .stat-change {
            font-size: 0.8rem;
            font-weight: 600;
            margin-top: 0.75rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .stat-change.positive { color: #10b981; }
        .stat-change.negative { color: #ef4444; }
        .stat-change.warning  { color: #f59e0b; }

        /* ===== CONTENT GRID ===== */
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        @media (max-width: 1024px) {
            .content-grid { grid-template-columns: 1fr; }
        }

        .card {
            background: #fff;
            border-radius: 18px;
            padding: 1.75rem;
            box-shadow: 0 10px 25px rgba(50,50,93,0.08);
            transition: box-shadow 0.3s;
        }

        .card:hover {
            box-shadow: 0 15px 40px rgba(50,50,93,0.13);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f1f5f9;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e293b;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-title i { color: #667eea; }

        .view-all-link {
            color: #667eea;
            font-weight: 600;
            font-size: 0.9rem;
            text-decoration: none;
            transition: color 0.2s;
        }

        .view-all-link:hover { color: #4c51bf; text-decoration: underline; }

        /* ===== LISTINGS ===== */
        .listing-item {
            padding: 1rem 0;
            border-bottom: 1px solid #f1f5f9;
            transition: background 0.2s;
        }

        .listing-item:last-child { border-bottom: none; }
        .listing-item:hover { background: #f8fafc; margin: 0 -1rem; padding: 1rem; border-radius: 10px; }

        .listing-row {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .listing-thumb {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1.3rem;
            flex-shrink: 0;
        }

        .listing-info { flex: 1; min-width: 0; }

        .listing-title {
            font-weight: 600;
            color: #1e293b;
            font-size: 1rem;
            margin-bottom: 3px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .listing-meta {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.8rem;
            color: #94a3b8;
        }

        .listing-category {
            background: #e0e7ff;
            color: #4338ca;
            padding: 2px 8px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.75rem;
        }

        .listing-price {
            font-size: 1.15rem;
            font-weight: 800;
            color: #10b981;
            flex-shrink: 0;
        }

        .listing-status {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        /* Listing statuses */
        .listing-status.active     { background: #d1fae5; color: #065f46; }
        .listing-status.pending    { background: #fef3c7; color: #92400e; }
        .listing-status.sold       { background: #dbeafe; color: #1e40af; }
        .listing-status.swapped    { background: #ede9fe; color: #5b21b6; }
        .listing-status.rejected   { background: #fee2e2; color: #991b1b; }

        /* Complaint statuses — distinct colors matching Complaints.aspx */
        .listing-status.inprogress { background: #cfe2ff; color: #084298; }  /* In Progress – light blue */
        .listing-status.completed  { background: #d1e7dd; color: #0f5132; }  /* Completed   – light green */
        .listing-status.rejected   { background: #f8d7da; color: #842029; }  /* Rejected    – light red  */
        .listing-status.pending    { background: #fff3cd; color: #856404; }  /* Pending     – light amber */

        /* ===== QUICK ACTIONS ===== */
        .quick-actions { display: grid; gap: 12px; }

        .quick-action {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 16px;
            background: #f8fafc;
            border-radius: 12px;
            text-decoration: none;
            color: #334155;
            transition: all 0.2s;
            border: 2px solid transparent;
            position: relative;
        }

        .quick-action:hover {
            background: #fff;
            border-color: #667eea;
            transform: translateX(4px);
            color: #1e293b;
        }

        .qa-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1rem;
            flex-shrink: 0;
        }

        .qa-blue   { background: linear-gradient(135deg, #667eea, #764ba2); }
        .qa-green  { background: linear-gradient(135deg, #10b981, #059669); }
        .qa-orange { background: linear-gradient(135deg, #f59e0b, #f97316); }
        .qa-purple { background: linear-gradient(135deg, #8b5cf6, #7c3aed); }
        .qa-pink   { background: linear-gradient(135deg, #ec4899, #db2777); }
        .qa-red    { background: linear-gradient(135deg, #ef4444, #dc2626); }

        .qa-text strong {
            display: block;
            font-size: 0.95rem;
            font-weight: 600;
            color: #1e293b;
        }

        .qa-text span {
            font-size: 0.8rem;
            color: #94a3b8;
        }

        /* ===== REPLY NOTIFICATION BADGE ===== */
        .reply-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            min-width: 28px;
            height: 28px;
            padding: 0 8px;
            border-radius: 999px;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: #fff;
            font-size: 0.78rem;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 6px 15px rgba(239, 68, 68, 0.45);
            animation: badgePop 0.5s cubic-bezier(0.68, -0.55, 0.27, 1.55),
                       badgePulse 2s ease-in-out 0.5s infinite;
            border: 2px solid #fff;
            z-index: 10;
        }

        @keyframes badgePop {
            0%   { transform: scale(0); opacity: 0; }
            60%  { transform: scale(1.25); opacity: 1; }
            100% { transform: scale(1); opacity: 1; }
        }

        @keyframes badgePulse {
            0%, 100% { box-shadow: 0 6px 15px rgba(239, 68, 68, 0.45); }
            50%      { box-shadow: 0 6px 22px rgba(239, 68, 68, 0.85),
                                   0 0 0 6px rgba(239, 68, 68, 0.15); }
        }

        /* ===== ACTIVITY ===== */
        .activity-list {
            list-style: none;
            max-height: 400px;
            overflow-y: auto;
            padding: 0;
            margin: 0;
        }

        .activity-item {
            padding: 12px 0;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .activity-item:last-child { border-bottom: none; }

        .activity-icon {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            flex-shrink: 0;
        }

        .activity-icon.offer    { background: #dbeafe; color: #1e40af; }
        .activity-icon.listing  { background: #d1fae5; color: #065f46; }
        .activity-icon.trade    { background: #fef3c7; color: #92400e; }
        .activity-icon.payment  { background: #ede9fe; color: #5b21b6; }
        .activity-icon.complaint{ background: #fee2e2; color: #991b1b; }
        .activity-icon.info     { background: #e2e8f0; color: #475569; }

        .activity-content { flex: 1; min-width: 0; }

        .activity-title {
            font-weight: 600;
            font-size: 0.9rem;
            color: #1e293b;
            margin-bottom: 2px;
        }

        .activity-desc {
            font-size: 0.8rem;
            color: #64748b;
            margin-bottom: 3px;
            line-height: 1.3;
        }

        .activity-time {
            font-size: 0.72rem;
            color: #94a3b8;
        }

        /* ===== PAYMENT TABLE ===== */
        .payment-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f1f5f9;
        }
        .payment-item:last-child { border-bottom: none; }

        .payment-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .payment-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1rem;
        }

        .payment-details strong {
            display: block;
            font-size: 0.9rem;
            color: #1e293b;
        }

        .payment-details span {
            font-size: 0.75rem;
            color: #94a3b8;
        }

        .payment-amount {
            font-weight: 800;
            font-size: 1rem;
        }

        .payment-amount.credit { color: #10b981; }
        .payment-amount.debit  { color: #ef4444; }

        /* ===== COMPLAINT ===== */
        .complaint-item {
            padding: 1rem 0;
            border-bottom: 1px solid #f1f5f9;
        }
        .complaint-item:last-child { border-bottom: none; }

        .complaint-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 6px;
            gap: 10px;
        }

        .complaint-subject {
            font-weight: 600;
            font-size: 0.95rem;
            color: #1e293b;
        }

        .complaint-desc {
            font-size: 0.82rem;
            color: #64748b;
            margin-bottom: 6px;
            line-height: 1.35;
        }

        .complaint-meta {
            font-size: 0.75rem;
            color: #94a3b8;
            display: flex;
            gap: 12px;
        }

        /* ===== EMPTY STATE ===== */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: #94a3b8;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.35;
            display: block;
        }

        .empty-state p {
            font-size: 0.9rem;
            margin: 0 0 1rem 0;
        }

        .empty-state a {
            color: #667eea;
            font-weight: 600;
            text-decoration: none;
        }
        .empty-state a:hover { text-decoration: underline; }

        /* ===== SCROLLBAR ===== */
        .activity-list::-webkit-scrollbar { width: 6px; }
        .activity-list::-webkit-scrollbar-track { background: transparent; }
        .activity-list::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
        .activity-list::-webkit-scrollbar-thumb:hover { background: #94a3b8; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .dashboard-container { padding: 1.25rem; }
            .dashboard-header h1 { font-size: 1.6rem; }
            .stat-value { font-size: 1.8rem; }
            .card { padding: 1.25rem; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="dashboard-container">

        <!-- ===== HEADER ===== -->
        <div class="dashboard-header">
            <div>
                <h1>Welcome back, <asp:Label ID="lblStudentName" runat="server" Text="Student"></asp:Label>! 👋</h1>
                <p>Here's what's happening with your StudySwap account today.</p>
            </div>
            <div class="header-actions">
                <a href="Listing.aspx" class="btn-action btn-primary">
                    <i class="fas fa-plus"></i> Sell Item
                </a>
                <a href="BrowseListings.aspx" class="btn-action btn-light">
                    <i class="fas fa-shopping-cart"></i> Buy / Browse
                </a>
            </div>
        </div>

        <!-- ===== STATS ===== -->
        <div class="stats-grid">

            <a href="MyListing.aspx" class="stat-card">
                <div class="stat-card-header">
                    <div>
                        <div class="stat-value"><asp:Label ID="lblActiveListings" runat="server" Text="0"></asp:Label></div>
                        <div class="stat-label">My Listings</div>
                    </div>
                    <div class="stat-icon blue"><i class="fas fa-tags"></i></div>
                </div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i>
                    <asp:Label ID="lblNewListingsWeek" runat="server" Text="0"></asp:Label> new this week
                </div>
            </a>

            <a href="PurchaseListing.aspx" class="stat-card green">
                <div class="stat-card-header">
                    <div>
                        <div class="stat-value"><asp:Label ID="lblMyPurchases" runat="server" Text="0"></asp:Label></div>
                        <div class="stat-label">My Purchase Listing</div>
                    </div>
                    <div class="stat-icon green"><i class="fas fa-shopping-bag"></i></div>
                </div>
                <div class="stat-change positive">
                    <i class="fas fa-check"></i> Items bought
                </div>
            </a>

            <a href="ViewEarningDetails.aspx" class="stat-card purple">
                <div class="stat-card-header">
                    <div>
                        <div class="stat-value">₹<asp:Label ID="lblTotalEarnings" runat="server" Text="0"></asp:Label></div>
                        <div class="stat-label">Total Earnings</div>
                    </div>
                    <div class="stat-icon purple"><i class="fas fa-coins"></i></div>
                </div>
                <div class="stat-change positive">
                    <i class="fas fa-wallet"></i> From sold items
                </div>
            </a>

            <a href="Complains.aspx" class="stat-card red">
                <div class="stat-card-header">
                    <div>
                        <div class="stat-value"><asp:Label ID="lblMyComplaints" runat="server" Text="0"></asp:Label></div>
                        <div class="stat-label">My Complaints</div>
                    </div>
                    <div class="stat-icon red"><i class="fas fa-flag"></i></div>
                </div>
                <div class="stat-change warning">
                    <i class="fas fa-clock"></i>
                    <asp:Label ID="lblPendingComplaints" runat="server" Text=""></asp:Label> 
                </div>
            </a>

        </div>

        <!-- ===== ROW 1: My Listings + Quick Actions ===== -->
        <div class="content-grid">
            <!-- My Listings -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-tags"></i> My Recent Listings</h3>
                    <a href="MyListing.aspx" class="view-all-link">View All →</a>
                </div>
                <asp:Repeater ID="rptMyListings" runat="server">
                    <ItemTemplate>
                        <div class="listing-item">
                            <div class="listing-row">
                                <div class="listing-thumb">
                                    <i class="fas fa-book"></i>
                                </div>
                                <div class="listing-info">
                                    <div class="listing-title"><%# Eval("Title") %></div>
                                    <div class="listing-meta">
                                        <span class="listing-category"><%# Eval("CategoryName") %></span>
                                        <span><i class="far fa-clock"></i> <%# GetTimeAgo(Convert.ToDateTime(Eval("PostedDate"))) %></span>
                                    </div>
                                </div>
                                <div class="listing-price">₹<%# Eval("SellingPrice", "{0:N0}") %></div>
                                <span class="listing-status <%# GetListingStatusClass(Eval("Status").ToString()) %>">
                                    <%# Eval("Status") %>
                                </span>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoListings" runat="server" Visible="false" CssClass="empty-state">
                    <i class="fas fa-box-open"></i>
                    <p>You haven't posted any listings yet.</p>
                    <a href="Listing.aspx">Post your first listing →</a>
                </asp:Panel>
            </div>

            <!-- Quick Actions -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-bolt"></i> Quick Actions</h3>
                </div>
                <div class="quick-actions">
                    <a href="Listing.aspx" class="quick-action">
                        <div class="qa-icon qa-blue"><i class="fas fa-plus"></i></div>
                        <div class="qa-text">
                            <strong>Sell an Item</strong>
                            <span>Post a new listing</span>
                        </div>
                    </a>
                    <a href="BrowseListings.aspx" class="quick-action">
                        <div class="qa-icon qa-green"><i class="fas fa-search"></i></div>
                        <div class="qa-text">
                            <strong>Browse Listings</strong>
                            <span>Find what you need</span>
                        </div>
                    </a>
                    <a href="PurchaseListing.aspx" class="quick-action">
                        <div class="qa-icon qa-orange"><i class="fas fa-shopping-cart"></i></div>
                        <div class="qa-text">
                            <strong>My Purchases</strong>
                            <span>View your orders</span>
                        </div>
                    </a>
                    <a href="ViewPurchaseRequestReaction.aspx" class="quick-action">
                        <div class="qa-icon qa-purple"><i class="fas fa-exchange-alt"></i></div>
                        <div class="qa-text">
                            <strong>My Requests</strong>
                            <span>Track your requests</span>
                        </div>
                        <asp:Panel ID="pnlReplyBadge" runat="server" Visible="false" CssClass="reply-badge">
                            +<asp:Label ID="lblReplyCount" runat="server" Text="0"></asp:Label>
                        </asp:Panel>
                    </a>
                    <a href="PaymentHistory.aspx" class="quick-action">
                        <div class="qa-icon qa-pink"><i class="fas fa-wallet"></i></div>
                        <div class="qa-text">
                            <strong>Payments</strong>
                            <span>View transaction history</span>
                        </div>
                    </a>
                    <a href="Complains.aspx" class="quick-action">
                        <div class="qa-icon qa-red"><i class="fas fa-flag"></i></div>
                        <div class="qa-text">
                            <strong>Support</strong>
                            <span>Raise a complaint</span>
                        </div>
                    </a>
                </div>
            </div>
        </div>

        <!-- ===== ROW 2: Recent Payments + My Complaints ===== -->
        <div class="content-grid">
            <!-- Recent Payments -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-receipt"></i> Recent Payments</h3>
                    <a href="PaymentHistory.aspx" class="view-all-link">View All →</a>
                </div>
                <asp:Repeater ID="rptRecentPayments" runat="server">
                    <ItemTemplate>
                        <div class="payment-item">
                            <div class="payment-info">
                                <div class="payment-icon" style="background: linear-gradient(135deg, #667eea, #764ba2);">
                                    <i class="fas fa-arrow-<%# GetPaymentDirection(Eval("PayerUserID").ToString()) %>"></i>
                                </div>
                                <div class="payment-details">
                                    <strong><%# Eval("Title") %></strong>
                                    <span><%# GetTimeAgo(Convert.ToDateTime(Eval("PaymentDate"))) %></span>
                                </div>
                            </div>
                            <div class="payment-amount <%# GetPaymentAmountClass(Eval("PayerUserID").ToString()) %>">
                                <%# GetPaymentPrefix(Eval("PayerUserID").ToString()) %>₹<%# Eval("Amount", "{0:N0}") %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoPayments" runat="server" Visible="false" CssClass="empty-state">
                    <i class="fas fa-receipt"></i>
                    <p>No payment transactions yet.</p>
                </asp:Panel>
            </div>

            <!-- My Complaints -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-flag"></i> My Complaints</h3>
                    <a href="Complains.aspx" class="view-all-link">View All →</a>
                </div>
                <asp:Repeater ID="rptRecentComplaints" runat="server">
                    <ItemTemplate>
                        <div class="complaint-item">
                            <div class="complaint-header">
                                <span class="complaint-subject"><%# Eval("Subject") %></span>
                                <span class="listing-status <%# GetComplaintStatusClass(Eval("Status").ToString()) %>">
                                    <%# Eval("Status") %>
                                </span>
                            </div>
                            <div class="complaint-desc"><%# Truncate(Eval("Description").ToString(), 80) %></div>
                            <div class="complaint-meta">
                                <span><i class="fas fa-tag"></i> <%# Eval("Category") %></span>
                                <span><i class="far fa-clock"></i> <%# GetTimeAgo(Convert.ToDateTime(Eval("CreatedDate"))) %></span>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoComplaints" runat="server" Visible="false" CssClass="empty-state">
                    <i class="fas fa-check-circle"></i>
                    <p>No complaints raised. All good!</p>
                </asp:Panel>
            </div>
        </div>

        <!-- ===== ROW 3: Recent Activity + Useful Links ===== -->
        <div class="content-grid">
            <!-- Recent Activity -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-history"></i> Recent Activity</h3>
                </div>
                <div class="activity-list">
                    <asp:Repeater ID="rptRecentActivity" runat="server">
                        <ItemTemplate>
                            <div class="activity-item">
                                <div class="activity-icon <%# Eval("ActivityType") %>">
                                    <i class="<%# Eval("ActivityIcon") %>"></i>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-title"><%# Eval("ActivityTitle") %></div>
                                    <div class="activity-desc"><%# Eval("ActivityDesc") %></div>
                                    <div class="activity-time"><%# GetTimeAgo(Convert.ToDateTime(Eval("ActivityDate"))) %></div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <asp:Panel ID="pnlNoActivity" runat="server" Visible="false" CssClass="empty-state">
                    <i class="fas fa-stream"></i>
                    <p>No recent activity to show.</p>
                </asp:Panel>
            </div>

            <!-- Useful Links -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-link"></i> Useful Links</h3>
                </div>
                <div class="quick-actions">
                    <a href="MyListing.aspx" class="quick-action">
                        <div class="qa-icon qa-blue"><i class="fas fa-list"></i></div>
                        <div class="qa-text">
                            <strong>My Listings</strong>
                            <span>Manage your items</span>
                        </div>
                    </a>
                    <a href="PurchaseRequests.aspx" class="quick-action">
                        <div class="qa-icon qa-green"><i class="fas fa-bullhorn"></i></div>
                        <div class="qa-text">
                            <strong>Purchase Requests</strong>
                            <span>Items you're looking for</span>
                        </div>
                    </a>
                    <a href="ReceivedRequests.aspx" class="quick-action">
                        <div class="qa-icon qa-orange"><i class="fas fa-inbox"></i></div>
                        <div class="qa-text">
                            <strong>Received Requests</strong>
                            <span>Requests on your listings</span>
                        </div>
                    </a>
                    <a href="MyProfile.aspx" class="quick-action">
                        <div class="qa-icon qa-purple"><i class="fas fa-user-circle"></i></div>
                        <div class="qa-text">
                            <strong>My Profile</strong>
                            <span>Update your details</span>
                        </div>
                    </a>
                </div>
            </div>
        </div>

    </div>

</asp:Content>