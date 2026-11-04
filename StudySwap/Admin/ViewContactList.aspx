<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewContactList.aspx.cs" Inherits="StudySwap.Admin.ViewContactList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Contact Messages | Admin Panel
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .contact-page {
            font-family: 'Poppins', sans-serif;
            padding: 10px 0 40px 0;
        }

        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 22px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 600;
            color: #1e293b;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .page-title i {
            color: #667eea;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 22px;
        }

        .stat-card {
            background: #fff;
            border-radius: 14px;
            padding: 18px 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
            display: flex;
            align-items: center;
            gap: 14px;
            border-left: 4px solid #667eea;
        }

        .stat-card.pending { border-left-color: #f59e0b; }
        .stat-card.responded { border-left-color: #10b981; }
        .stat-card.total { border-left-color: #667eea; }

        .stat-icon {
            width: 46px;
            height: 46px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: #fff;
            background: linear-gradient(135deg, #667eea, #764ba2);
            flex-shrink: 0;
        }

        .stat-card.pending .stat-icon { background: linear-gradient(135deg, #f59e0b, #f97316); }
        .stat-card.responded .stat-icon { background: linear-gradient(135deg, #10b981, #059669); }

        .stat-info h3 {
            margin: 0;
            font-size: 22px;
            font-weight: 700;
            color: #1e293b;
        }

        .stat-info p {
            margin: 0;
            font-size: 12px;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
            overflow: hidden;
        }

        .table-toolbar {
            padding: 16px 22px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            background: #f8fafc;
        }

        .table-toolbar h5 {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
        }

        .search-input {
            padding: 9px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 13px;
            outline: none;
            min-width: 240px;
            font-family: 'Poppins', sans-serif;
        }

        .search-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.15);
        }

        .contact-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13.5px;
        }

        .contact-table thead {
            background: #f1f5f9;
        }

        .contact-table th {
            padding: 13px 14px;
            text-align: left;
            font-weight: 600;
            color: #475569;
            font-size: 12.5px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            white-space: nowrap;
        }

        .contact-table td {
            padding: 14px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
            vertical-align: middle;
        }

        .contact-table tbody tr:hover {
            background: #f8fafc;
        }

        .contact-table tbody tr:last-child td {
            border-bottom: none;
        }

        .subject-cell {
            max-width: 200px;
            font-weight: 500;
            color: #1e293b;
        }

        .email-cell {
            color: #667eea;
            font-size: 12.5px;
        }

        .mobile-cell {
            font-size: 12.5px;
            white-space: nowrap;
        }

        .mobile-cell a {
            color: #10b981;
            text-decoration: none;
            font-weight: 500;
        }

        .mobile-cell a:hover {
            text-decoration: underline;
        }

        .mobile-cell .no-mobile {
            color: #94a3b8;
            font-style: italic;
        }

        .msg-preview {
            max-width: 250px;
            color: #64748b;
            font-size: 12.5px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .badge {
            display: inline-block;
            padding: 5px 11px;
            border-radius: 20px;
            font-size: 11.5px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .badge-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .badge-responded {
            background: #d1fae5;
            color: #065f46;
        }

        .badge-read {
            background: #dbeafe;
            color: #1e40af;
        }

        .btn-view {
            padding: 7px 14px;
            border: none;
            border-radius: 7px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            transition: all 0.2s;
        }

        .btn-view:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        /* ✅ NEW: Delete button styles */
        .btn-delete {
            padding: 7px 14px;
            border: none;
            border-radius: 7px;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: #fff;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            transition: all 0.2s;
        }

        .btn-delete:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
        }

        .action-cell {
            white-space: nowrap;
            display: flex;
            gap: 6px;
            align-items: center;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #94a3b8;
        }

        .empty-state i {
            font-size: 50px;
            margin-bottom: 14px;
            opacity: 0.4;
        }

        .empty-state p {
            margin: 0;
            font-size: 15px;
        }

        /* ===== MODAL ===== */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.6);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            padding: 20px;
            backdrop-filter: blur(3px);
        }

        .modal-overlay.show {
            display: flex;
        }

        .modal-box {
            background: #fff;
            border-radius: 16px;
            width: 100%;
            max-width: 620px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.3);
            animation: modalIn 0.25s ease;
        }

        /* ✅ NEW: Smaller modal for delete confirmation */
        .modal-box.modal-sm {
            max-width: 440px;
        }

        @keyframes modalIn {
            from { opacity: 0; transform: translateY(20px) scale(0.97); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }

        .modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 16px 16px 0 0;
        }

        /* ✅ NEW: Red header for delete modal */
        .modal-header.danger {
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }

        .modal-header h4 {
            margin: 0;
            color: #fff;
            font-size: 17px;
            font-weight: 600;
        }

        .modal-close {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: #fff;
            width: 34px;
            height: 34px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-close:hover {
            background: rgba(255, 255, 255, 0.35);
        }

        .modal-body {
            padding: 24px;
        }

        .field-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }

        .field-group label {
            display: block;
            font-size: 11.5px;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }

        .field-group .value {
            font-size: 14px;
            color: #1e293b;
            font-weight: 500;
        }

        .field-group .value a {
            color: #10b981;
            text-decoration: none;
        }

        .field-group .value a:hover {
            text-decoration: underline;
        }

        .field-group.full {
            grid-column: 1 / -1;
        }

        .message-box {
            background: #f8fafc;
            border-left: 4px solid #667eea;
            border-radius: 8px;
            padding: 14px 16px;
            font-size: 13.5px;
            color: #334155;
            line-height: 1.6;
            white-space: pre-wrap;
            word-wrap: break-word;
        }

        .response-textarea {
            width: 100%;
            min-height: 120px;
            padding: 12px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            font-size: 13.5px;
            font-family: 'Poppins', sans-serif;
            resize: vertical;
            outline: none;
        }

        .response-textarea:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.15);
        }

        .modal-footer {
            padding: 16px 24px;
            border-top: 1px solid #e2e8f0;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            background: #f8fafc;
            border-radius: 0 0 16px 16px;
        }

        .btn {
            padding: 10px 22px;
            border: none;
            border-radius: 9px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            transition: all 0.2s;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
        }

        .btn-primary:hover {
            box-shadow: 0 6px 18px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #e2e8f0;
            color: #475569;
        }

        .btn-secondary:hover {
            background: #cbd5e1;
        }

        /* ✅ NEW: Danger button */
        .btn-danger {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: #fff;
        }

        .btn-danger:hover {
            box-shadow: 0 6px 18px rgba(239, 68, 68, 0.4);
        }

        .alert-msg {
            padding: 12px 18px;
            border-radius: 10px;
            margin-bottom: 18px;
            font-size: 13.5px;
            font-weight: 500;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border-left: 4px solid #10b981;
        }

        /* ✅ NEW: Error alert */
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border-left: 4px solid #ef4444;
        }

        /* ✅ NEW: Delete confirmation body */
        .delete-confirm-body {
            text-align: center;
            padding: 10px 0;
        }

        .delete-confirm-body .delete-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: #fee2e2;
            color: #ef4444;
            font-size: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 18px auto;
        }

        .delete-confirm-body h3 {
            margin: 0 0 8px 0;
            font-size: 18px;
            font-weight: 600;
            color: #1e293b;
        }

        .delete-confirm-body p {
            margin: 0 0 6px 0;
            font-size: 13.5px;
            color: #64748b;
            line-height: 1.5;
        }

        .delete-confirm-body .msg-info {
            background: #f8fafc;
            border-radius: 8px;
            padding: 12px 16px;
            margin-top: 16px;
            text-align: left;
            font-size: 13px;
            color: #334155;
        }

        .delete-confirm-body .msg-info strong {
            color: #1e293b;
        }

        @media (max-width: 768px) {
            .field-row { grid-template-columns: 1fr; }
            .contact-table { font-size: 12px; }
            .contact-table th, .contact-table td { padding: 10px 8px; }
            .msg-preview, .subject-cell { max-width: 120px; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="contact-page">

        <!-- ===== PAGE HEADER ===== -->
        <div class="page-header">
            <h2 class="page-title">
                <i class="bi bi-envelope-paper-fill"></i> Contact Messages
            </h2>
            <asp:Button ID="btnRefresh" runat="server" Text="↻ Refresh" CssClass="btn btn-secondary"
                OnClick="btnRefresh_Click" CausesValidation="false" />
        </div>

        <!-- ===== ALERT ===== -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false">
            <div class="alert-msg alert-success" id="alertBox">
                <asp:Label ID="lblAlert" runat="server"></asp:Label>
            </div>
        </asp:Panel>

        <!-- ===== TABLE ===== -->
        <div class="table-card">
            <div class="table-toolbar">
                <h5><i class="bi bi-list-ul"></i> All Contact Submissions</h5>
                <input type="text" id="txtSearch" class="search-input"
                    placeholder="🔍 Search name, email, mobile, subject..." onkeyup="filterTable()" />
            </div>

            <asp:Repeater ID="rptMessages" runat="server" OnItemCommand="rptMessages_ItemCommand">
                <HeaderTemplate>
                    <div style="overflow-x:auto;">
                    <table class="contact-table" id="contactTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Mobile</th>
                                <th>Subject</th>
                                <th>Message</th>
                                <th>Received</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>

                <ItemTemplate>
                    <tr>
                        <td><%# Eval("MessageID") %></td>
                        <td><%# Eval("Name") %></td>
                        <td class="email-cell"><%# Eval("Email") %></td>

                        <td class="mobile-cell">
                            <%# FormatMobile(Eval("Mobile")) %>
                        </td>

                        <td class="subject-cell"><%# Eval("Subject") %></td>
                        <td class="msg-preview"><%# Truncate(Eval("Message"), 60) %></td>
                        <td><%# Eval("ReceivedDate", "{0:dd MMM yyyy, hh:mm tt}") %></td>

                        <%-- ✅ NEW: Actions column with View + Delete --%>
                        <td class="action-cell">
                            <asp:LinkButton ID="lnkView" runat="server"
                                CssClass="btn-view"
                                CommandName="ViewMsg"
                                CommandArgument='<%# Eval("MessageID") %>'
                                CausesValidation="false">
                                <i class="bi bi-eye"></i> View
                            </asp:LinkButton>

                            <asp:LinkButton ID="lnkDelete" runat="server"
                                CssClass="btn-delete"
                                CommandName="DeleteMsg"
                                CommandArgument='<%# Eval("MessageID") %>'
                                CausesValidation="false"
                                OnClientClick="return showDeleteConfirm(this);">
                                <i class="bi bi-trash"></i> Delete
                            </asp:LinkButton>
                        </td>
                    </tr>
                </ItemTemplate>

                <FooterTemplate>
                        </tbody>
                    </table>
                    </div>
                    <asp:Panel ID="pnlEmpty" runat="server"
                        Visible='<%# rptMessages.Items.Count == 0 %>'>
                        <div class="empty-state">
                            <i class="bi bi-inbox"></i>
                            <p>No contact messages yet.</p>
                        </div>
                    </asp:Panel>
                </FooterTemplate>
            </asp:Repeater>
        </div>

    </div>

    <!-- ===== VIEW / REPLY MODAL ===== -->
    <div id="msgModal" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <h4><i class="bi bi-envelope-open-fill"></i> Message Details</h4>
                <button type="button" class="modal-close" onclick="closeModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>

            <div class="modal-body">
                <div class="field-row">
                    <div class="field-group">
                        <label>Name</label>
                        <div class="value" id="mName">—</div>
                    </div>
                    <div class="field-group">
                        <label>Email</label>
                        <div class="value" id="mEmail">—</div>
                    </div>
                </div>

                <div class="field-row">
                    <div class="field-group">
                        <label>Mobile</label>
                        <div class="value" id="mMobile">—</div>
                    </div>
                    <div class="field-group">
                        <label>Subject</label>
                        <div class="value" id="mSubject">—</div>
                    </div>
                </div>

                <div class="field-row">
                    <div class="field-group full">
                        <label>Received Date</label>
                        <div class="value" id="mDate">—</div>
                    </div>
                </div>

                <div class="field-group full" style="margin-bottom: 18px;">
                    <label>Message</label>
                    <div class="message-box" id="mMessage">—</div>
                </div>

                <div class="field-group full">
                    <label>Admin Response</label>
                    <asp:TextBox ID="txtResponse" runat="server"
                        CssClass="response-textarea"
                        TextMode="MultiLine"
                        placeholder="Type your response here..."></asp:TextBox>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                <asp:Button ID="btnSendResponse" runat="server"
                    Text="✉ Send Response"
                    CssClass="btn btn-primary"
                    OnClick="btnSendResponse_Click" />
            </div>
        </div>
    </div>

    <!-- ===== DELETE CONFIRMATION MODAL ===== -->
    <div id="deleteModal" class="modal-overlay">
        <div class="modal-box modal-sm">
            <div class="modal-header danger">
                <h4><i class="bi bi-exclamation-triangle-fill"></i> Confirm Delete</h4>
                <button type="button" class="modal-close" onclick="closeDeleteModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>

            <div class="modal-body">
                <div class="delete-confirm-body">
                    <div class="delete-icon">
                        <i class="bi bi-trash"></i>
                    </div>
                    <h3>Delete this message?</h3>
                    <p>This action cannot be undone. The message will be permanently removed from the database.</p>

                    <div class="msg-info">
                        <div><strong>From:</strong> <span id="delName">—</span></div>
                        <div><strong>Subject:</strong> <span id="delSubject">—</span></div>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeDeleteModal()">Cancel</button>
                <asp:Button ID="btnConfirmDelete" runat="server"
                    Text="🗑 Delete Permanently"
                    CssClass="btn btn-danger"
                    OnClick="btnConfirmDelete_Click" />
            </div>
        </div>
    </div>

    <!-- Hidden fields -->
    <asp:HiddenField ID="hfMessageID" runat="server" />
    <asp:HiddenField ID="hfDeleteID" runat="server" />

    <script>
        // Client-side search filter
        function filterTable() {
            var input = document.getElementById("txtSearch").value.toLowerCase();
            var rows = document.querySelectorAll("#contactTable tbody tr");
            rows.forEach(function (row) {
                var text = row.innerText.toLowerCase();
                row.style.display = text.indexOf(input) > -1 ? "" : "none";
            });
        }

        function openModal() {
            document.getElementById("msgModal").classList.add("show");
        }

        function closeModal() {
            document.getElementById("msgModal").classList.remove("show");
        }

        function openDeleteModal() {
            document.getElementById("deleteModal").classList.add("show");
        }

        function closeDeleteModal() {
            document.getElementById("deleteModal").classList.remove("show");
        }

        // ✅ NEW: Show delete confirmation - intercepts the LinkButton click
        function showDeleteConfirm(btn) {
            // Extract row data for display in the confirmation modal
            var row = btn.closest("tr");
            if (row) {
                var cells = row.querySelectorAll("td");
                if (cells.length >= 6) {
                    document.getElementById("delName").innerText = cells[1].innerText.trim();
                    document.getElementById("delSubject").innerText = cells[4].innerText.trim();
                }
            }

            // Store the command argument (MessageID) in the hidden field
            var msgId = btn.getAttribute("href").match(/__doPostBack\(['"]([^'"]+)['"]/);
            // Fallback: read from the row's first cell
            if (row && row.cells.length > 0) {
                document.getElementById("hfDeleteID").value = row.cells[0].innerText.trim();
            }

            // Store the LinkButton's unique ID so we can trigger postback later
            var uniqueId = btn.getAttribute("href").match(/__doPostBack\(['"]([^'"]+)['"]/);
            if (uniqueId) {
                document.getElementById("hfDeleteID").value = uniqueId[1] + "|" + (row ? row.cells[0].innerText.trim() : "");
            }

            openDeleteModal();
            return false; // Prevent immediate postback
        }

        // Close modal on overlay click
        document.getElementById("msgModal").addEventListener("click", function (e) {
            if (e.target === this) closeModal();
        });

        document.getElementById("deleteModal").addEventListener("click", function (e) {
            if (e.target === this) closeDeleteModal();
        });

        // Close on ESC
        document.addEventListener("keydown", function (e) {
            if (e.key === "Escape") {
                closeModal();
                closeDeleteModal();
            }
        });
    </script>

</asp:Content>