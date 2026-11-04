<%@ Page Title="Payment History"
    Language="C#"
    MasterPageFile="~/Student/Student.Master"
    AutoEventWireup="true"
    CodeBehind="PaymentHistory.aspx.cs"
    Inherits="StudySwap.Student.PaymentHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        /* ============================================================
           PAYMENT HISTORY — STRONG UI
           ============================================================ */

        .ph-wrapper {
            padding: 2rem 2.5rem;
            background: #f0f4f8;
            min-height: 100vh;
            font-family: 'Poppins', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* ===== Page Header ===== */
        .page-header {
            position: relative;
            background: linear-gradient(135deg, #4f46e5 0%, #06b6d4 100%);
            color: #fff;
            padding: 2rem 2.25rem;
            border-radius: 20px;
            margin-bottom: 1.75rem;
            box-shadow: 0 15px 35px rgba(79, 70, 229, 0.3);
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
        }

        .page-header::after {
            content: '';
            position: absolute;
            bottom: -60%;
            right: 15%;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.06);
            border-radius: 50%;
        }

        .page-header-inner {
            position: relative;
            z-index: 1;
        }

        .page-header h3 {
            margin: 0 0 6px 0;
            font-weight: 700;
            font-size: 1.9rem;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .page-header h3 .ph-icon {
            background: rgba(255, 255, 255, 0.2);
            width: 50px;
            height: 50px;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
        }

        .page-header p {
            margin: 0;
            opacity: 0.9;
            font-size: 0.95rem;
        }

        /* ===== Summary Cards ===== */
        .summary-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.25rem;
            margin-bottom: 1.75rem;
        }

        .summary-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 1.5rem;
            box-shadow: 0 8px 20px rgba(50, 50, 93, 0.08);
            transition: transform 0.3s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.3s;
            position: relative;
            overflow: hidden;
        }

        .summary-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }

        .summary-card.green::before  { background: linear-gradient(90deg, #10b981, #059669); }
        .summary-card.red::before    { background: linear-gradient(90deg, #ef4444, #dc2626); }
        .summary-card.amber::before  { background: linear-gradient(90deg, #f59e0b, #f97316); }

        .summary-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 40px rgba(50, 50, 93, 0.15);
        }

        .summary-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.75rem;
        }

        .summary-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.35rem;
            color: #fff;
            flex-shrink: 0;
        }

        .summary-icon.blue  { background: linear-gradient(135deg, #667eea, #764ba2); }
        .summary-icon.green { background: linear-gradient(135deg, #10b981, #059669); }
        .summary-icon.red   { background: linear-gradient(135deg, #ef4444, #dc2626); }
        .summary-icon.amber { background: linear-gradient(135deg, #f59e0b, #f97316); }

        .summary-value {
            font-size: 1.9rem;
            font-weight: 800;
            color: #1e293b;
            line-height: 1;
        }

        .summary-title {
            font-size: 0.78rem;
            font-weight: 600;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-top: 6px;
        }

        /* ===== Table Card ===== */
        .table-card {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(50, 50, 93, 0.08);
            overflow: hidden;
        }

        .table-card-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 2px solid #f1f5f9;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .table-card-header h5 {
            margin: 0;
            font-weight: 700;
            color: #1e293b;
            font-size: 1.05rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .table-card-header h5 i { color: #4f46e5; }

        .table-card-header .record-count {
            font-size: 0.8rem;
            color: #94a3b8;
            font-weight: 600;
            background: #f1f5f9;
            padding: 5px 12px;
            border-radius: 999px;
        }

        /* ===== GridView / Table Styling ===== */
        .table-responsive {
            overflow-x: auto;
            padding: 0;
        }

        .table {
            width: 100%;
            margin-bottom: 0;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        .table thead {
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
        }

        .table th {
            padding: 14px 18px;
            font-weight: 700;
            color: #475569;
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            text-align: left;
            border: none;
            border-bottom: 2px solid #e2e8f0;
            white-space: nowrap;
        }

        .table td {
            padding: 16px 18px;
            color: #1e293b;
            vertical-align: middle;
            border: none;
            border-top: 1px solid #f1f5f9;
            font-size: 0.88rem;
        }

        .table tbody tr {
            transition: background 0.2s;
        }

        .table tbody tr:hover {
            background-color: #f8fafc;
        }

        .table tbody tr:last-child td {
            border-bottom: none;
        }

        /* ===== Status Badges ===== */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            white-space: nowrap;
        }

        .badge-success {
            background-color: #d1fae5;
            color: #065f46;
        }

        .badge-danger {
            background-color: #fee2e2;
            color: #991b1b;
        }

        .badge-warning {
            background-color: #fef3c7;
            color: #92400e;
        }

        /* ===== Empty State ===== */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #94a3b8;
        }

        .empty-state .empty-illustration {
            width: 100px;
            height: 100px;
            margin: 0 auto 1.5rem;
            border-radius: 50%;
            background: linear-gradient(135deg, #e0e7ff, #cffafe);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
        }

        .empty-state i {
            font-size: 2.5rem;
            display: block;
        }

        .empty-state h5 {
            color: #1e293b;
            font-weight: 700;
            font-size: 1.15rem;
            margin-bottom: 8px;
        }

        .empty-state p {
            font-size: 0.9rem;
            margin-bottom: 0;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.5;
        }

        /* ===== Responsive ===== */
        @media (max-width: 768px) {
            .ph-wrapper { padding: 1.25rem; }
            .page-header { padding: 1.5rem; }
            .page-header h3 { font-size: 1.4rem; }
            .summary-value { font-size: 1.5rem; }
            .table th, .table td { padding: 12px; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="ph-wrapper">

        <!-- Header -->
        <div class="page-header">
            <div class="page-header-inner">
                <h3>
                    <span class="ph-icon"><i class="fas fa-receipt"></i></span>
                    Payment History
                </h3>
                <p>Track all your purchases and exchange payments</p>
            </div>
        </div>

        <!-- Summary Section -->

        <!-- Payment Table -->
        <div class="table-card">

            <div class="table-card-header">
                <h5><i class="fas fa-list-ul"></i> Transactions</h5>
                <span class="record-count">
                    <asp:Label ID="lblRecordCount" runat="server" Text="0"></asp:Label> records
                </span>
            </div>

            <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
                <div class="empty-illustration">💸</div>
                <h5>No payment history found</h5>
                <p>Your transactions will appear here once you make a purchase.</p>
            </asp:Panel>

            <div class="table-responsive">
                <asp:GridView ID="gvPayments"
                    runat="server"
                    AutoGenerateColumns="false"
                    CssClass="table"
                    GridLines="None"
                    EmptyDataText="">

                    <Columns>

                        <asp:BoundField DataField="PaymentDate"
                            HeaderText="Date"
                            DataFormatString="{0:dd MMM yyyy}" />

                        <asp:BoundField DataField="ListingTitle"
                            HeaderText="Item" />

                        <asp:BoundField DataField="Amount"
                            HeaderText="Amount (₹)"
                            DataFormatString="{0:N2}" />

                        <asp:BoundField DataField="PaymentMethod"
                            HeaderText="Method" />

                        <asp:BoundField DataField="TransactionRef"
                            HeaderText="Transaction Ref" />

                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='badge <%# GetStatusClass(Eval("PaymentStatus").ToString()) %>'>
                                    <%# Eval("PaymentStatus") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>
            </div>

        </div>

    </div>

</asp:Content>