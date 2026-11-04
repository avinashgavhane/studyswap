<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewUsers.aspx.cs" Inherits="StudySwap.Admin.ViewUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Manage Students & Batches | Admin Panel
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .users-page { font-family: 'Poppins', sans-serif; padding: 10px 0 40px 0; }

        .page-header {
            display: flex; align-items: center; justify-content: space-between;
            flex-wrap: wrap; gap: 15px; margin-bottom: 22px;
        }
        .page-title {
            font-size: 24px; font-weight: 700; color: #1e293b; margin: 0;
            display: flex; align-items: center; gap: 10px;
        }
        .page-title i { color: #4f46e5; }

        /* ===== STATS ROW ===== */
        .stats-row {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 16px; margin-bottom: 24px;
        }
        .stat-card {
            background: #fff; border-radius: 14px; padding: 18px 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            display: flex; align-items: center; gap: 14px;
            border-left: 4px solid #6366f1; transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-2px); }
        .stat-card.passout { border-left-color: #ef4444; }
        .stat-card.year3 { border-left-color: #3b82f6; }
        .stat-card.junior { border-left-color: #10b981; }

        .stat-icon {
            width: 48px; height: 48px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; color: #fff; flex-shrink: 0;
            background: linear-gradient(135deg, #6366f1, #4f46e5);
        }
        .stat-card.passout .stat-icon { background: linear-gradient(135deg, #ef4444, #b91c1c); }
        .stat-card.year3 .stat-icon { background: linear-gradient(135deg, #3b82f6, #1d4ed8); }
        .stat-card.junior .stat-icon { background: linear-gradient(135deg, #10b981, #059669); }

        .stat-info h3 { margin: 0; font-size: 24px; font-weight: 700; color: #1e293b; }
        .stat-info p {
            margin: 2px 0 0 0; font-size: 11.5px; color: #64748b;
            text-transform: uppercase; letter-spacing: 0.5px; font-weight: 600;
        }

        /* ===== PASSOUT BATCH PURGE CARD ===== */
        .purge-card {
            background: #fff; border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            border: 1px solid #fee2e2; margin-bottom: 24px; overflow: hidden;
        }
        .purge-header {
            padding: 16px 22px; background: #fff5f5;
            border-bottom: 1px solid #fed7d7;
            display: flex; align-items: center; justify-content: space-between;
            flex-wrap: wrap; gap: 12px;
        }
        .purge-title-box { display: flex; align-items: center; gap: 12px; }
        .purge-icon-badge {
            width: 40px; height: 40px; border-radius: 10px;
            background: linear-gradient(135deg, #ef4444, #b91c1c);
            color: #fff; display: flex; align-items: center; justify-content: center;
            font-size: 18px; flex-shrink: 0;
        }
        .purge-header h4 { margin: 0; font-size: 16px; font-weight: 700; color: #991b1b; }
        .purge-header p { margin: 2px 0 0 0; font-size: 12.5px; color: #7f1d1d; }
        .purge-badge-tag {
            background: #fee2e2; color: #991b1b; padding: 4px 10px;
            border-radius: 20px; font-size: 11px; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.5px;
            border: 1px solid #fca5a5;
        }

        .purge-body { padding: 20px 22px; background: #fff; }
        .purge-controls {
            display: flex; align-items: center; flex-wrap: wrap; gap: 16px;
        }
        .purge-group {
            display: flex; flex-direction: column; gap: 6px; flex: 1; min-width: 260px;
        }
        .purge-group label {
            font-size: 12.5px; font-weight: 600; color: #334155; margin: 0;
        }
        .purge-select {
            padding: 9px 14px; border: 1.5px solid #cbd5e1; border-radius: 9px;
            font-size: 13.5px; font-family: 'Poppins', sans-serif;
            background-color: #fff; color: #1e293b; outline: none;
            transition: all 0.2s;
        }
        .purge-select:focus { border-color: #ef4444; box-shadow: 0 0 0 3px rgba(239,68,68,0.12); }

        .btn-purge {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: #fff; border: none; border-radius: 9px;
            padding: 11px 22px; font-size: 13.5px; font-weight: 600;
            cursor: pointer; font-family: 'Poppins', sans-serif;
            display: inline-flex; align-items: center; gap: 8px;
            transition: all 0.2s; white-space: nowrap; align-self: flex-end;
        }
        .btn-purge:hover {
            box-shadow: 0 4px 15px rgba(239,68,68,0.4);
            transform: translateY(-1px); color: #fff;
        }

        .purge-info-strip {
            margin-top: 14px; padding: 10px 14px; background: #f8fafc;
            border-radius: 8px; border-left: 3px solid #94a3b8;
            font-size: 12px; color: #64748b; display: flex; align-items: center; gap: 8px;
        }

        /* ===== TABLE CARD & TOOLBAR ===== */
        .table-card {
            background: #fff; border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06); overflow: hidden;
        }
        .table-toolbar {
            padding: 16px 22px; border-bottom: 1px solid #e2e8f0;
            display: flex; align-items: center; justify-content: space-between;
            flex-wrap: wrap; gap: 14px; background: #f8fafc;
        }
        .table-toolbar h5 { margin: 0; font-size: 16px; font-weight: 700; color: #1e293b; display: flex; align-items: center; gap: 8px; }
        
        .toolbar-filters {
            display: flex; align-items: center; flex-wrap: wrap; gap: 10px;
        }
        .filter-select {
            padding: 8px 12px; border: 1.5px solid #cbd5e1; border-radius: 8px;
            font-size: 12.5px; font-family: 'Poppins', sans-serif;
            background-color: #fff; color: #334155; outline: none;
            transition: all 0.2s;
        }
        .filter-select:focus { border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99,102,241,0.12); }

        .search-input {
            padding: 8px 14px; border: 1.5px solid #cbd5e1; border-radius: 8px;
            font-size: 12.5px; outline: none; min-width: 220px;
            font-family: 'Poppins', sans-serif;
        }
        .search-input:focus { border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99,102,241,0.12); }

        /* ===== USER TABLE ===== */
        .user-table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .user-table thead { background: #f1f5f9; }
        .user-table th {
            padding: 13px 14px; text-align: left; font-weight: 600;
            color: #475569; font-size: 12px; text-transform: uppercase;
            letter-spacing: 0.4px; white-space: nowrap;
        }
        .user-table td {
            padding: 13px 14px; border-bottom: 1px solid #f1f5f9;
            color: #334155; vertical-align: middle;
        }
        .user-table tbody tr:hover { background: #f8fafc; }
        .user-table tbody tr:last-child td { border-bottom: none; }

        /* ===== BADGES ===== */
        .batch-badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 10px; border-radius: 20px; font-size: 11.5px;
            font-weight: 600; white-space: nowrap;
        }
        .batch-passout { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; }
        .batch-yr3 { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
        .batch-yr2 { background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; }
        .batch-yr1 { background: #fffbeb; color: #b45309; border: 1px solid #fde68a; }
        .batch-unknown { background: #f1f5f9; color: #64748b; border: 1px solid #e2e8f0; }

        .badge-status {
            display: inline-block; padding: 4px 9px; border-radius: 20px;
            font-size: 11px; font-weight: 600; text-transform: uppercase;
        }
        .badge-active { background: #d1fae5; color: #065f46; }
        .badge-inactive { background: #e2e8f0; color: #475569; }
        .badge-suspended { background: #fee2e2; color: #991b1b; }

        .role-badge {
            display: inline-block; padding: 3px 8px; border-radius: 6px;
            font-size: 11px; font-weight: 600;
        }
        .role-student { background: #dbeafe; color: #1e40af; }
        .role-tutor { background: #ede9fe; color: #5b21b6; }
        .role-admin { background: #fef3c7; color: #92400e; }

        .dept-tag {
            font-size: 11.5px; font-weight: 600; color: #475569;
            background: #f1f5f9; padding: 2px 7px; border-radius: 5px;
            display: inline-block;
        }

        .btn-danger-sm {
            padding: 6px 12px; border: none; border-radius: 7px;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: #fff; font-size: 12px; font-weight: 500;
            cursor: pointer; text-decoration: none;
            font-family: 'Poppins', sans-serif;
            display: inline-flex; align-items: center; gap: 5px;
            transition: all 0.2s;
        }
        .btn-danger-sm:hover { box-shadow: 0 4px 10px rgba(239,68,68,0.35); color:#fff; }

        .btn {
            padding: 9px 20px; border: none; border-radius: 8px;
            font-size: 13px; font-weight: 600; cursor: pointer;
            font-family: 'Poppins', sans-serif; transition: all 0.2s;
        }
        .btn-secondary { background: #e2e8f0; color: #475569; }
        .btn-secondary:hover { background: #cbd5e1; }

        .alert-msg {
            padding: 13px 18px; border-radius: 10px;
            margin-bottom: 20px; font-size: 13.5px; font-weight: 500;
            display: flex; align-items: center; gap: 10px;
        }
        .alert-success { background: #d1fae5; color: #065f46; border-left: 4px solid #10b981; }
        .alert-error { background: #fee2e2; color: #991b1b; border-left: 4px solid #ef4444; }

        .empty-state { text-align: center; padding: 60px 20px; color: #94a3b8; }
        .empty-state i { font-size: 46px; margin-bottom: 12px; opacity: 0.4; }
        .empty-state p { margin: 0; font-size: 14.5px; }

        @media (max-width: 768px) {
            .stats-row { grid-template-columns: 1fr; }
            .purge-controls { flex-direction: column; align-items: stretch; }
            .btn-purge { align-self: stretch; justify-content: center; }
            .toolbar-filters { width: 100%; }
            .search-input { width: 100%; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="users-page">

        <!-- ===== PAGE HEADER ===== -->
        <div class="page-header">
            <h2 class="page-title">
                <i class="fa-solid fa-users"></i> Manage Students & Cohorts
            </h2>
            <asp:Button ID="btnRefresh" runat="server" Text="↻ Refresh Data"
                CssClass="btn btn-secondary"
                OnClick="btnRefresh_Click" CausesValidation="false" />
        </div>

        <!-- ===== ALERT ===== -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false">
            <div id="divAlert" runat="server" class="alert-msg alert-success">
                <i class="fa-solid fa-circle-info"></i>
                <asp:Label ID="lblAlert" runat="server"></asp:Label>
            </div>
        </asp:Panel>

        <!-- ===== STATS ROW ===== -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fa-solid fa-user-graduate"></i>
                </div>
                <div class="stat-info">
                    <h3><asp:Label ID="lblStatTotal" runat="server" Text="0"></asp:Label></h3>
                    <p>Total Registered Students</p>
                </div>
            </div>

            <div class="stat-card passout">
                <div class="stat-icon">
                    <i class="fa-solid fa-graduation-cap"></i>
                </div>
                <div class="stat-info">
                    <h3><asp:Label ID="lblStatPassout" runat="server" Text="0"></asp:Label></h3>
                    <p>4th Year (Passout Cohort)</p>
                </div>
            </div>

            <div class="stat-card year3">
                <div class="stat-icon">
                    <i class="fa-solid fa-book-bookmark"></i>
                </div>
                <div class="stat-info">
                    <h3><asp:Label ID="lblStatYear3" runat="server" Text="0"></asp:Label></h3>
                    <p>3rd Year (Pre-Final)</p>
                </div>
            </div>

            <div class="stat-card junior">
                <div class="stat-icon">
                    <i class="fa-solid fa-seedling"></i>
                </div>
                <div class="stat-info">
                    <h3><asp:Label ID="lblStatJunior" runat="server" Text="0"></asp:Label></h3>
                    <p>1st & 2nd Year (Junior)</p>
                </div>
            </div>
        </div>

        <!-- ===== PASSOUT BATCH PURGE MANAGEMENT PANEL ===== -->
        <div class="purge-card">
            <div class="purge-header">
                <div class="purge-title-box">
                    <div class="purge-icon-badge">
                        <i class="fa-solid fa-user-xmark"></i>
                    </div>
                    <div>
                        <h4>Passout Batch Management & Bulk Deletion</h4>
                        <p>Categorize graduating batches by year/semester and securely purge passout cohorts at academic year-end.</p>
                    </div>
                </div>
                <span class="purge-badge-tag">
                    <i class="fa-solid fa-triangle-exclamation"></i> Cohort Cleanup
                </span>
            </div>

            <div class="purge-body">
                <div class="purge-controls">
                    <div class="purge-group">
                        <label>
                            Select Batch to Purge:
                            <asp:Label ID="lblPurgeCount" runat="server" CssClass="text-danger fw-bold" Text=""></asp:Label>
                        </label>
                        <asp:DropDownList ID="ddlPurgeBatch" runat="server" CssClass="purge-select"
                            AutoPostBack="true" OnSelectedIndexChanged="ddlPurgeBatch_SelectedIndexChanged">
                            <asp:ListItem Value="4" Selected="True">🎓 4th Year (Semesters 7 & 8) — Final Passout Batch</asp:ListItem>
                            <asp:ListItem Value="3">📘 3rd Year (Semesters 5 & 6)</asp:ListItem>
                            <asp:ListItem Value="2">📗 2nd Year (Semesters 3 & 4)</asp:ListItem>
                            <asp:ListItem Value="1">📙 1st Year (Semesters 1 & 2)</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <asp:Button ID="btnPurgeBatch" runat="server" Text="🗑️ Purge Entire Batch"
                        CssClass="btn-purge" OnClick="btnPurgeBatch_Click"
                        OnClientClick="return confirm('⚠️ CRITICAL WARNING: You are about to permanently delete ALL students in the selected cohort!\n\nThis will completely remove:\n• Student accounts and profiles\n• All their item listings and uploaded photos\n• Purchase/Listing requests and transaction history\n• Associated complaints and notifications\n\nThis action is PERMANENT and IRREVERSIBLE.\n\nAre you sure you want to proceed?');" />
                </div>

                <div class="purge-info-strip">
                    <i class="fa-solid fa-circle-exclamation text-danger"></i>
                    <span><strong>Automated File & Data Cleanup:</strong> When a passout batch is purged, all related records across 7 database tables and their physical uploaded image files on the server disk are cleanly removed.</span>
                </div>
            </div>
        </div>

        <!-- ===== USERS DIRECTORY TABLE ===== -->
        <div class="table-card">
            <div class="table-toolbar">
                <h5><i class="fa-solid fa-address-book"></i> Registered Students Directory</h5>
                
                <div class="toolbar-filters">
                    <!-- Filter by Batch -->
                    <asp:DropDownList ID="ddlBatchFilter" runat="server" CssClass="filter-select"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlBatchFilter_SelectedIndexChanged">
                        <asp:ListItem Value="" Selected="True">All Batches / Semesters</asp:ListItem>
                        <asp:ListItem Value="4">🎓 4th Year (Passout Cohort • Sem 7-8)</asp:ListItem>
                        <asp:ListItem Value="3">📘 3rd Year (Sem 5-6)</asp:ListItem>
                        <asp:ListItem Value="2">📗 2nd Year (Sem 3-4)</asp:ListItem>
                        <asp:ListItem Value="1">📙 1st Year (Sem 1-2)</asp:ListItem>
                    </asp:DropDownList>

                    <input type="text" id="txtSearch" class="search-input"
                        placeholder="🔍 Search name, email, roll..." onkeyup="filterTable()" />
                </div>
            </div>

            <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                <HeaderTemplate>
                    <div style="overflow-x:auto;">
                    <table class="user-table" id="userTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Student Name</th>
                                <th>Email & Phone</th>
                                <th>Batch / Semester</th>
                                <th>Roll / Dept</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Verified</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>

                <ItemTemplate>
                    <tr>
                        <td><strong>#<%# Eval("UserID") %></strong></td>
                        <td>
                            <div style="font-weight:600; color:#1e293b;"><%# Eval("FullName") %></div>
                        </td>
                        <td>
                            <div style="color:#4f46e5; font-size:12.5px;"><i class="fa-regular fa-envelope"></i> <%# Eval("Email") %></div>
                            <div style="color:#64748b; font-size:11.5px;"><i class="fa-solid fa-phone"></i> <%# Eval("Phone") %></div>
                        </td>
                        <td>
                            <%# GetBatchBadge(Eval("YearOfStudy")) %>
                        </td>
                        <td>
                            <span class="dept-tag"><%# Eval("DeptCode") %></span>
                            <div style="font-size:11.5px; color:#64748b; margin-top:2px;">Roll: <%# Eval("RollNumber") %></div>
                        </td>
                        <td><%# GetRoleBadge(Eval("Role")) %></td>
                        <td><%# GetStatusBadge(Eval("Status")) %></td>
                        <td>
                            <%# (Eval("IsVerified") != null && Eval("IsVerified") != DBNull.Value && Convert.ToBoolean(Eval("IsVerified")))
                                ? "<span style='color:#10b981; font-weight:600;'><i class='fa-solid fa-circle-check'></i> Verified</span>"
                                : "<span style='color:#94a3b8;'><i class='fa-regular fa-circle'></i> Unverified</span>" %>
                        </td>
                        <td>
                            <asp:LinkButton ID="btnDelete" runat="server" 
                                CssClass="btn-danger-sm" 
                                CommandName="DeleteUser" 
                                CommandArgument='<%# Eval("UserID") %>'
                                OnClientClick="return confirm('Are you sure you want to permanently delete this student, their listings, and all uploaded photos?');">
                                <i class="fa-solid fa-trash-can"></i> Delete
                            </asp:LinkButton>
                        </td>
                    </tr>
                </ItemTemplate>

                <FooterTemplate>
                        </tbody>
                    </table>
                    </div>
                    <asp:Panel ID="pnlEmpty" runat="server"
                        Visible='<%# rptUsers.Items.Count == 0 %>'>
                        <div class="empty-state">
                            <i class="fa-solid fa-user-slash"></i>
                            <p>No students found for the selected batch/filter.</p>
                        </div>
                    </asp:Panel>
                </FooterTemplate>
            </asp:Repeater>
        </div>

    </div>

    <script>
        function filterTable() {
            var input = document.getElementById("txtSearch").value.toLowerCase();
            var rows = document.querySelectorAll("#userTable tbody tr");
            rows.forEach(function (row) {
                var text = row.innerText.toLowerCase();
                row.style.display = text.indexOf(input) > -1 ? "" : "none";
            });
        }
    </script>

</asp:Content>
