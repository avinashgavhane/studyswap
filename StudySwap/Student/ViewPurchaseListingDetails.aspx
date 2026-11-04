<%@ Page Title="My Purchase Requests" Language="C#" MasterPageFile="~/Student/Student.Master"
    AutoEventWireup="true" CodeBehind="ViewPurchaseListingDetails.aspx.cs"
    Inherits="StudySwap.Student.ViewPurchaseListingDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        /* ============================================================
           MY PURCHASE REQUESTS — VIEW + EDIT + DELETE
           ============================================================ */

        .pl-page {
            padding: 2rem 2.5rem;
            background: #f0f4f8;
            min-height: 100vh;
            font-family: 'Poppins', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* ===== HEADER ===== */
        .pl-header {
            position: relative;
            background: linear-gradient(135deg, #4f46e5 0%, #06b6d4 100%);
            color: #fff;
            padding: 2rem 2.25rem;
            border-radius: 20px;
            margin-bottom: 1.75rem;
            box-shadow: 0 15px 35px rgba(79, 70, 229, 0.3);
            overflow: hidden;
        }

        .pl-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 320px;
            height: 320px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
        }

        .pl-header::after {
            content: '';
            position: absolute;
            bottom: -60%;
            right: 15%;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.06);
            border-radius: 50%;
        }

        .pl-header-inner {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        .pl-header h1 {
            margin: 0 0 6px 0;
            font-weight: 700;
            font-size: 1.9rem;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .pl-header h1 .ph-icon {
            background: rgba(255, 255, 255, 0.2);
            width: 54px;
            height: 54px;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        .pl-header p {
            margin: 0;
            opacity: 0.92;
            font-size: 0.95rem;
        }

        .pl-header .count-pill {
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

        /* ===== CARD GRID ===== */
        .pl-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 1.5rem;
        }

        /* ===== REQUEST CARD ===== */
        .request-card {
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
            font-family: inherit;
        }

        .request-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
            background: linear-gradient(90deg, #4f46e5, #06b6d4);
        }

        .request-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 22px 45px rgba(50, 50, 93, 0.15);
        }

        /* ===== CARD HEAD ===== */
        .rc-head {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 1rem;
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
            flex: 1;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        /* ===== STATUS BADGE ===== */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-weight: 700;
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            white-space: nowrap;
            flex-shrink: 0;
        }

        .status-badge::before {
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            font-size: 0.65rem;
        }

        .status-active {
            background: #d1fae5;
            color: #065f46;
        }
        .status-active::before { content: '\f111'; }

        .status-deactive {
            background: #fee2e2;
            color: #991b1b;
        }
        .status-deactive::before { content: '\f00d'; }

        /* ===== META ROWS ===== */
        .rc-meta {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 1.1rem;
        }

        .rc-meta-row {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.86rem;
            color: #475569;
        }

        .rc-meta-icon {
            width: 30px;
            height: 30px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            flex-shrink: 0;
        }

        .rc-meta-icon.category { background: #ede9fe; color: #5b21b6; }
        .rc-meta-icon.date     { background: #dbeafe; color: #1e40af; }
        .rc-meta-icon.reaction { background: #fef3c7; color: #92400e; }

        .rc-meta-label {
            font-size: 0.68rem;
            font-weight: 700;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            display: block;
        }

        .rc-meta-value {
            font-weight: 600;
            color: #1e293b;
            font-size: 0.86rem;
        }

        /* ===== DESCRIPTION ===== */
        .rc-desc {
            color: #64748b;
            font-size: 0.88rem;
            line-height: 1.55;
            margin-bottom: 1.25rem;
            padding: 1rem 1.25rem;
            background: #f8fafc;
            border-radius: 12px;
            border-left: 4px solid #4f46e5;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 4;
            -webkit-box-orient: vertical;
            min-height: 80px;
            flex-grow: 1;
        }

        /* ===== ACTION BUTTONS ===== */
        .rc-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .rc-btn {
            flex: 1;
            min-width: 100px;
            padding: 11px 18px !important;
            border: none !important;
            border-radius: 12px !important;
            font-size: 0.82rem !important;
            font-weight: 700 !important;
            font-family: inherit !important;
            cursor: pointer !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 7px !important;
            transition: all 0.25s !important;
            text-decoration: none !important;
            letter-spacing: 0.02em;
            white-space: nowrap;
        }

        /* Edit */
        .btn-edit {
            background: linear-gradient(135deg, #f59e0b, #d97706) !important;
            color: #fff !important;
            box-shadow: 0 6px 16px rgba(245, 158, 11, 0.3) !important;
        }
        .btn-edit:hover {
            transform: translateY(-2px) !important;
            box-shadow: 0 12px 25px rgba(245, 158, 11, 0.45) !important;
            color: #fff !important;
        }
        .btn-edit::before {
            content: '\f044';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
        }

        /* Delete */
        .btn-delete {
            background: #fff !important;
            color: #dc2626 !important;
            border: 2px solid #fee2e2 !important;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04) !important;
        }
        .btn-delete:hover {
            background: #fef2f2 !important;
            border-color: #fca5a5 !important;
            color: #b91c1c !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 10px 25px rgba(220, 38, 38, 0.2) !important;
        }
        .btn-delete::before {
            content: '\f2ed';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
        }

        /* Save */
        .btn-save {
            background: linear-gradient(135deg, #10b981, #059669) !important;
            color: #fff !important;
            box-shadow: 0 6px 16px rgba(16, 185, 129, 0.3) !important;
        }
        .btn-save:hover {
            transform: translateY(-2px) !important;
            box-shadow: 0 12px 25px rgba(16, 185, 129, 0.45) !important;
            color: #fff !important;
        }
        .btn-save::before {
            content: '\f00c';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
        }

        /* Cancel */
        .btn-cancel {
            background: #fff !important;
            color: #475569 !important;
            border: 2px solid #e2e8f0 !important;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04) !important;
        }
        .btn-cancel:hover {
            background: #f8fafc !important;
            border-color: #cbd5e1 !important;
            color: #1e293b !important;
            transform: translateY(-2px) !important;
        }
        .btn-cancel::before {
            content: '\f00d';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
        }

        /* ===== EDIT MODE ===== */
        .edit-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 1.25rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f1f5f9;
        }

        .edit-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            background: linear-gradient(135deg, #f59e0b, #d97706);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1rem;
            flex-shrink: 0;
            box-shadow: 0 6px 15px rgba(245, 158, 11, 0.35);
        }

        .edit-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1e293b;
            margin: 0;
        }

        .edit-subtitle {
            font-size: 0.8rem;
            color: #94a3b8;
            margin: 2px 0 0 0;
        }

        /* ===== FORM ===== */
        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            display: block;
            font-size: 0.72rem;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 6px;
        }

        .form-control,
        .form-select {
            width: 100% !important;
            padding: 12px 14px !important;
            font-size: 0.92rem !important;
            font-family: inherit !important;
            border-radius: 12px !important;
            border: 1.5px solid #e2e8f0 !important;
            background: #f8fafc !important;
            color: #1e293b !important;
            font-weight: 500 !important;
            transition: all 0.2s ease !important;
            box-sizing: border-box !important;
            outline: none !important;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #4f46e5 !important;
            background: #fff !important;
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1) !important;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 90px;
        }

        /* ===== EMPTY STATE ===== */
        .pl-empty {
            grid-column: 1 / -1;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(50, 50, 93, 0.08);
            padding: 4rem 2rem;
            text-align: center;
            color: #94a3b8;
        }

        .pl-empty-illustration {
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

        .pl-empty h5 {
            color: #1e293b;
            font-weight: 700;
            font-size: 1.2rem;
            margin-bottom: 8px;
        }

        .pl-empty p {
            font-size: 0.92rem;
            color: #64748b;
            margin: 0;
            max-width: 420px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.55;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .pl-page { padding: 1.25rem; }
            .pl-header { padding: 1.5rem; }
            .pl-header h1 { font-size: 1.4rem; }
            .pl-grid { grid-template-columns: 1fr; }
            .request-card { padding: 1.4rem; }
            .rc-btn { flex: 1 1 100%; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="pl-page">

        <!-- ===== HEADER ===== -->
        <div class="pl-header">
            <div class="pl-header-inner">
                <div>
                    <h1>
                        <span class="ph-icon"><i class="fas fa-clipboard-list"></i></span>
                        My Purchase Requests
                    </h1>
                    <p>View, edit, or remove the items you're looking for on StudySwap.</p>
                </div>
                <span class="count-pill">
                    <i class="fas fa-list-ul"></i>
                    <asp:Label ID="lblRequestCount" runat="server" Text="0" /> requests
                </span>
            </div>
        </div>

        <!-- ===== REQUEST GRID ===== -->
        <div class="pl-grid">

            <asp:Repeater ID="rptRequests" runat="server"
                OnItemCommand="rptRequests_ItemCommand"
                OnItemDataBound="rptRequests_ItemDataBound">
                <ItemTemplate>

                    <!-- ========== DISPLAY MODE ========== -->
                    <asp:Panel ID="pnlDisplay" runat="server" Visible='<%# !IsEditing(Container) %>'>
                        <div class="request-card" role="region" aria-label="Purchase Request">

                            <!-- Head: icon + title + status -->
                            <div class="rc-head">
                                <div class="rc-thumb"><i class="fas fa-box"></i></div>
                                <h4 class="rc-title"><%# Eval("ItemName") %></h4>
                                <span class='status-badge <%# GetStatusClass(Eval("Status").ToString()) %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </div>

                            <!-- Meta: category + created date + reaction -->
                            <div class="rc-meta">

                                <div class="rc-meta-row">
                                    <div class="rc-meta-icon category"><i class="fas fa-tag"></i></div>
                                    <div>
                                        <span class="rc-meta-label">Category</span>
                                        <span class="rc-meta-value"><%# Eval("CategoryName") %></span>
                                    </div>
                                </div>

                                <div class="rc-meta-row">
                                    <div class="rc-meta-icon date"><i class="far fa-calendar-alt"></i></div>
                                    <div>
                                        <span class="rc-meta-label">Posted On</span>
                                        <span class="rc-meta-value">
                                            <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("dd MMM yyyy") %>
                                        </span>
                                    </div>
                                </div>

                                <asp:Panel ID="pnlReaction" runat="server"
                                    Visible='<%# Eval("Reaction") != null && Eval("Reaction").ToString() != "" %>'>
                                    <div class="rc-meta-row">
                                        <div class="rc-meta-icon reaction"><i class="fas fa-bolt"></i></div>
                                        <div>
                                            <span class="rc-meta-label">Reaction</span>
                                            <span class="rc-meta-value"><%# Eval("Reaction") %></span>
                                        </div>
                                    </div>
                                </asp:Panel>

                            </div>

                            <!-- Description -->
                            <div class="rc-desc"><%# Eval("Description") %></div>

                            <!-- Actions -->
                            <div class="rc-actions">
                                <asp:Button ID="btnEdit" runat="server"
                                    Text="Edit"
                                    CommandName="EditRequest"
                                    CommandArgument='<%# Eval("PurchaseRequestID") %>'
                                    CssClass="rc-btn btn-edit" />

                                <asp:Button ID="btnDelete" runat="server"
                                    Text="Delete"
                                    CommandName="DeleteRequest"
                                    CommandArgument='<%# Eval("PurchaseRequestID") %>'
                                    CssClass="rc-btn btn-delete"
                                    OnClientClick="return confirm('Are you sure you want to delete this purchase request?');" />
                            </div>

                        </div>
                    </asp:Panel>

                    <!-- ========== EDIT MODE ========== -->
                    <asp:Panel ID="pnlEdit" runat="server"
                        Visible='<%# IsEditing(Container) %>'
                        CssClass="request-card"
                        role="form"
                        aria-label="Edit Purchase Request">

                        <div class="edit-header">
                            <div class="edit-icon"><i class="fas fa-pencil-alt"></i></div>
                            <div>
                                <h4 class="edit-title">Edit Purchase Request</h4>
                                <p class="edit-subtitle">Update your item details</p>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Item Name</label>
                            <asp:TextBox ID="txtItemNameEdit" runat="server"
                                Text='<%# Eval("ItemName") %>'
                                CssClass="form-control" />
                        </div>

                        <div class="form-group">
                            <label>Category</label>
                            <asp:DropDownList ID="ddlCategoryEdit" runat="server" CssClass="form-select" />
                        </div>

                        <div class="form-group">
                            <label>Description</label>
                            <asp:TextBox ID="txtDescriptionEdit" runat="server"
                                Text='<%# Eval("Description") %>'
                                TextMode="MultiLine" Rows="3"
                                CssClass="form-control" />
                        </div>

                        <div class="form-group">
                            <label>Status</label>
                            <asp:DropDownList ID="ddlStatusEdit" runat="server" CssClass="form-select">
                                <asp:ListItem Value="Active">Active</asp:ListItem>
                                <asp:ListItem Value="Deactive">Deactive</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="rc-actions">
                            <asp:Button ID="btnSave" runat="server"
                                Text="Save Changes"
                                CommandName="SaveRequest"
                                CommandArgument='<%# Eval("PurchaseRequestID") %>'
                                CssClass="rc-btn btn-save" />

                            <asp:Button ID="btnCancel" runat="server"
                                Text="Cancel"
                                CommandName="CancelEdit"
                                CssClass="rc-btn btn-cancel" />
                        </div>

                    </asp:Panel>

                </ItemTemplate>
            </asp:Repeater>

            <!-- ========== EMPTY STATE ========== -->
            <asp:Panel ID="pnlNoRequests" runat="server" Visible="false" CssClass="pl-empty">
                <div class="pl-empty-illustration">📝</div>
                <h5>No purchase requests yet</h5>
                <p>You haven't posted any purchase requests. When you're looking for something, post a request and students will reply!</p>
            </asp:Panel>

        </div>

    </div>

</asp:Content>