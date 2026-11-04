<%@ Page Title="My Earnings" Language="C#" MasterPageFile="~/Student/Student.Master"
    AutoEventWireup="true" CodeBehind="ViewEarningDetails.aspx.cs"
    Inherits="StudySwap.Student.ViewEarningDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        /* ============================================================
           MY EARNINGS — POWERFUL UI
           ============================================================ */

        .earn-page {
            padding: 2rem 2.5rem;
            background: #f0f4f8;
            min-height: 100vh;
            font-family: 'Poppins', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* ===== HEADER ===== */
        .earn-header {
            position: relative;
            background: linear-gradient(135deg, #10b981 0%, #059669 50%, #06b6d4 100%);
            color: #fff;
            padding: 2rem 2.25rem;
            border-radius: 20px;
            margin-bottom: 1.75rem;
            box-shadow: 0 15px 35px rgba(16, 185, 129, 0.3);
            overflow: hidden;
        }

        .earn-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 320px;
            height: 320px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
        }

        .earn-header::after {
            content: '';
            position: absolute;
            bottom: -60%;
            right: 15%;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.06);
            border-radius: 50%;
        }

        .earn-header-inner {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        .earn-header h1 {
            margin: 0 0 6px 0;
            font-weight: 700;
            font-size: 1.9rem;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .earn-header h1 .eh-icon {
            background: rgba(255, 255, 255, 0.2);
            width: 54px;
            height: 54px;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        .earn-header p {
            margin: 0;
            opacity: 0.92;
            font-size: 0.95rem;
        }

        .earn-header .total-pill {
            background: rgba(255, 255, 255, 0.18);
            backdrop-filter: blur(10px);
            padding: 14px 24px;
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 12px;
        }

        .earn-header .total-pill .tp-icon {
            width: 40px;
            height: 40px;
            border-radius: 11px;
            background: rgba(255, 255, 255, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.05rem;
        }

        .earn-header .total-pill .tp-text {
            display: flex;
            flex-direction: column;
        }

        .earn-header .total-pill .tp-label {
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            opacity: 0.85;
        }

        .earn-header .total-pill .tp-value {
            font-size: 1.4rem;
            font-weight: 800;
            line-height: 1.1;
        }

        /* ===== SUMMARY CARDS ===== */
        .earn-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.25rem;
            margin-bottom: 1.75rem;
        }

        .sum-card {
            background: #fff;
            border-radius: 18px;
            padding: 1.5rem;
            box-shadow: 0 8px 20px rgba(50, 50, 93, 0.08);
            transition: transform 0.3s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.3s;
            position: relative;
            overflow: hidden;
        }

        .sum-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
            background: linear-gradient(90deg, #10b981, #059669);
        }

        .sum-card.blue::before   { background: linear-gradient(90deg, #3b82f6, #1e40af); }
        .sum-card.amber::before  { background: linear-gradient(90deg, #f59e0b, #d97706); }
        .sum-card.purple::before { background: linear-gradient(90deg, #8b5cf6, #7c3aed); }

        .sum-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 40px rgba(50, 50, 93, 0.15);
        }

        .sum-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.75rem;
        }

        .sum-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            color: #fff;
            flex-shrink: 0;
        }

        .sum-icon.green  { background: linear-gradient(135deg, #10b981, #059669); }
        .sum-icon.blue   { background: linear-gradient(135deg, #3b82f6, #1e40af); }
        .sum-icon.amber  { background: linear-gradient(135deg, #f59e0b, #d97706); }
        .sum-icon.purple { background: linear-gradient(135deg, #8b5cf6, #7c3aed); }

        .sum-value {
            font-size: 1.75rem;
            font-weight: 800;
            color: #1e293b;
            line-height: 1;
        }

        .sum-label {
            font-size: 0.72rem;
            font-weight: 700;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-top: 6px;
        }

        /* ===== FILTER BAR ===== */
        .earn-filter {
            background: #fff;
            border-radius: 16px;
            padding: 1.25rem 1.5rem;
            box-shadow: 0 8px 20px rgba(50, 50, 93, 0.06);
            margin-bottom: 1.5rem;
            display: flex;
            gap: 14px;
            align-items: flex-end;
            flex-wrap: wrap;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            flex: 1;
            min-width: 160px;
        }

        .filter-group label {
            font-size: 0.7rem;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .filter-input {
            padding: 10px 14px;
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            font-size: 0.9rem;
            font-family: inherit;
            color: #1e293b;
            outline: none;
            transition: all 0.2s;
            background: #f8fafc;
        }

        .filter-input:focus {
            border-color: #10b981;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
        }

        .filter-actions {
            display: flex;
            gap: 8px;
        }

        .btn-filter {
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.85rem;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            transition: all 0.2s;
            font-family: inherit;
        }

        .btn-filter-primary {
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff;
        }
        .btn-filter-primary:hover {
            box-shadow: 0 8px 18px rgba(16, 185, 129, 0.35);
            transform: translateY(-2px);
            color: #fff;
        }

        .btn-filter-light {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
        }
        .btn-filter-light:hover {
            background: #e2e8f0;
        }

        /* ===== TABLE CARD ===== */
        .earn-table-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(50, 50, 93, 0.08);
            overflow: hidden;
        }

        .earn-table-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 2px solid #f1f5f9;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .earn-table-header h5 {
            margin: 0;
            font-weight: 700;
            color: #1e293b;
            font-size: 1.05rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .earn-table-header h5 i { color: #10b981; }

        .record-count {
            font-size: 0.8rem;
            color: #94a3b8;
            font-weight: 600;
            background: #f1f5f9;
            padding: 5px 12px;
            border-radius: 999px;
        }

        .table-responsive { overflow-x: auto; }

        .earn-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        .earn-table thead {
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
        }

        .earn-table th {
            padding: 14px 18px;
            font-weight: 700;
            color: #475569;
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            text-align: left;
            border-bottom: 2px solid #e2e8f0;
            white-space: nowrap;
        }

        .earn-table td {
            padding: 16px 18px;
            color: #1e293b;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
            font-size: 0.88rem;
        }

        .earn-table tbody tr {
            transition: background 0.2s;
        }

        .earn-table tbody tr:hover {
            background: #f8fafc;
        }

        .earn-table tbody tr:last-child td {
            border-bottom: none;
        }

        .cell-item {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 200px;
        }

        .item-thumb {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: linear-gradient(135deg, #10b981, #059669);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1rem;
            flex-shrink: 0;
        }

        .item-name {
            font-weight: 600;
            color: #1e293b;
            font-size: 0.9rem;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            max-width: 220px;
        }

        .item-ref {
            font-size: 0.72rem;
            color: #94a3b8;
            margin-top: 2px;
        }

        .cell-date {
            font-weight: 600;
            color: #64748b;
            font-size: 0.85rem;
            white-space: nowrap;
        }

        .cell-buyer {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .buyer-avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3b82f6, #1e40af);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 0.7rem;
            font-weight: 700;
            flex-shrink: 0;
        }

        .buyer-name {
            font-weight: 600;
            color: #334155;
            font-size: 0.85rem;
        }

        .cell-amount {
            font-weight: 800;
            font-size: 1rem;
            color: #10b981;
            white-space: nowrap;
        }

        .method-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 12px;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 600;
            background: #f1f5f9;
            color: #475569;
            white-space: nowrap;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 12px;
            border-radius: 999px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            white-space: nowrap;
        }

        .badge-success { background: #d1fae5; color: #065f46; }
        .badge-warning { background: #fef3c7; color: #92400e; }
        .badge-danger  { background: #fee2e2; color: #991b1b; }

        /* ===== EMPTY STATE ===== */
        .earn-empty {
            text-align: center;
            padding: 4rem 2rem;
            color: #94a3b8;
        }

        .earn-empty-illustration {
            width: 110px;
            height: 110px;
            margin: 0 auto 1.5rem;
            border-radius: 50%;
            background: linear-gradient(135deg, #d1fae5, #cffafe);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.75rem;
        }

        .earn-empty h5 {
            color: #1e293b;
            font-weight: 700;
            font-size: 1.2rem;
            margin-bottom: 8px;
        }

        .earn-empty p {
            font-size: 0.92rem;
            color: #64748b;
            margin: 0 0 1.5rem 0;
            max-width: 420px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.55;
        }

        .earn-empty a {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff;
            padding: 12px 24px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.25s;
        }

        .earn-empty a:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(16, 185, 129, 0.35);
            color: #fff;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .earn-page { padding: 1.25rem; }
            .earn-header { padding: 1.5rem; }
            .earn-header h1 { font-size: 1.4rem; }
            .sum-value { font-size: 1.4rem; }
            .earn-filter { padding: 1rem; }
            .earn-table th, .earn-table td { padding: 12px; }
            .item-name { max-width: 140px; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="earn-page">

        <!-- ===== HEADER ===== -->
        <div class="earn-header">
            <div class="earn-header-inner">
                <div>
                    <h1>
                        <span class="eh-icon"><i class="fas fa-hand-holding-usd"></i></span>
                        My Earnings
                    </h1>
                    <p>Every rupee you've earned from selling your items on StudySwap.</p>
                </div>
                <div class="total-pill">
                    <div class="tp-icon"><i class="fas fa-wallet"></i></div>
                    <div class="tp-text">
                        <span class="tp-label">Total Earned</span>
                        <span class="tp-value">₹<asp:Label ID="lblHeaderTotal" runat="server" Text="0" /></span>
                    </div>
                </div>
            </div>
        </div>

        <!-- ===== SUMMARY CARDS ===== -->
        <div class="earn-summary">

            <div class="sum-card">
                <div class="sum-top">
                    <div>
                        <div class="sum-value">₹<asp:Label ID="lblTotalEarned" runat="server" Text="0" /></div>
                        <div class="sum-label">Total Earned</div>
                    </div>
                    <div class="sum-icon green"><i class="fas fa-coins"></i></div>
                </div>
            </div>

            <div class="sum-card blue">
                <div class="sum-top">
                    <div>
                        <div class="sum-value"><asp:Label ID="lblTotalSales" runat="server" Text="0" /></div>
                        <div class="sum-label">Items Sold</div>
                    </div>
                    <div class="sum-icon blue"><i class="fas fa-shopping-bag"></i></div>
                </div>
            </div>

            <div class="sum-card amber">
                <div class="sum-top">
                    <div>
                        <div class="sum-value">₹<asp:Label ID="lblAvgEarning" runat="server" Text="0" /></div>
                        <div class="sum-label">Avg. Per Sale</div>
                    </div>
                    <div class="sum-icon amber"><i class="fas fa-chart-line"></i></div>
                </div>
            </div>

            <div class="sum-card purple">
                <div class="sum-top">
                    <div>
                        <div class="sum-value"><asp:Label ID="lblLastEarningDate" runat="server" Text="—" /></div>
                        <div class="sum-label">Last Sale</div>
                    </div>
                    <div class="sum-icon purple"><i class="fas fa-clock"></i></div>
                </div>
            </div>

        </div>

        <!-- ===== FILTER BAR ===== -->
        <div class="earn-filter">
            <div class="filter-group">
                <label>From Date</label>
                <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date" CssClass="filter-input" />
            </div>
            <div class="filter-group">
                <label>To Date</label>
                <asp:TextBox ID="txtToDate" runat="server" TextMode="Date" CssClass="filter-input" />
            </div>
            <div class="filter-actions">
                <asp:Button ID="btnFilter" runat="server" Text="Apply Filter"
                    CssClass="btn-filter btn-filter-primary" OnClick="btnFilter_Click" />
                <asp:Button ID="btnReset" runat="server" Text="Reset"
                    CssClass="btn-filter btn-filter-light" OnClick="btnReset_Click" />
            </div>
        </div>

        <!-- ===== EARNINGS TABLE ===== -->
        <div class="earn-table-card">
            <div class="earn-table-header">
                <h5><i class="fas fa-list-ul"></i> Earning Transactions</h5>
                <span class="record-count">
                    <asp:Label ID="lblRecordCount" runat="server" Text="0" /> records
                </span>
            </div>

            <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="earn-empty">
                <div class="earn-empty-illustration">💰</div>
                <h5>No earnings yet</h5>
                <p>Once someone buys one of your listings, your earnings will appear here.</p>
                <a href="Listing.aspx">
                    <i class="fas fa-plus"></i> List an Item to Sell
                </a>
            </asp:Panel>

            <div class="table-responsive">
                <asp:Repeater ID="rptEarnings" runat="server">
                    <HeaderTemplate>
                        <table class="earn-table">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Item Sold</th>
                                    <th>Buyer</th>
                                    <th>Amount</th>
                                    <th>Method</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td>
                                <div class="cell-date">
                                    <i class="far fa-calendar"></i>
                                    <%# Convert.ToDateTime(Eval("PaymentDate")).ToString("dd MMM yyyy") %>
                                </div>
                            </td>
                            <td>
                                <div class="cell-item">
                                    <div class="item-thumb"><i class="fas fa-box"></i></div>
                                    <div>
                                        <div class="item-name"><%# Eval("ListingTitle") %></div>
                                        <div class="item-ref">Listing #<%# Eval("ListingID") %></div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="cell-buyer">
                                    <div class="buyer-avatar"><%# GetInitials(Eval("BuyerName").ToString()) %></div>
                                    <span class="buyer-name"><%# Eval("BuyerName") %></span>
                                </div>
                            </td>
                            <td>
                                <span class="cell-amount">+ ₹<%# Eval("Amount", "{0:N0}") %></span>
                            </td>
                            <td>
                                <span class="method-pill">
                                    <i class="fas fa-<%# GetMethodIcon(Eval("PaymentMethod").ToString()) %>"></i>
                                    <%# Eval("PaymentMethod") %>
                                </span>
                            </td>
                            <td>
                                <span class="badge <%# GetStatusClass(Eval("PaymentStatus").ToString()) %>">
                                    <%# Eval("PaymentStatus") %>
                                </span>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>

    </div>

</asp:Content>