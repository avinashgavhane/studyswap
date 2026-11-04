<%@ Page Title="Verify Students"
    Language="C#"
    MasterPageFile="~/Admin/Admin.Master"
    AutoEventWireup="true"
    CodeBehind="VerifyStudent.aspx.cs"
    Inherits="StudySwap.Admin.VerifyStudent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Verify Students
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../Content/VerifyStudent.css" rel="stylesheet" />

    <div class="verify-wrapper">
        <!-- Header -->
        <div class="header-section">
            <div class="header-left">
                <h1 class="page-title">
                    <span class="title-icon">✓</span>
                    Student Verification
                </h1>
                <p class="page-description">Review and approve pending student registrations</p>
            </div>
            <div class="header-right">
                <div class="pending-count">
                    <span class="count-number"><asp:Literal ID="litPendingCount" runat="server">0</asp:Literal></span>
                    <span class="count-label">Pending Approvals</span>
                </div>
            </div>
        </div>

        <!-- Alert Message -->
        <asp:Panel ID="pnlMessage" runat="server" CssClass="alert-box" Visible="false">
            <span class="alert-icon"><asp:Literal ID="litMessageIcon" runat="server"></asp:Literal></span>
            <span class="alert-text"><asp:Literal ID="litMessage" runat="server"></asp:Literal></span>
            <button type="button" class="alert-close" onclick="this.parentElement.style.display='none'">×</button>
        </asp:Panel>

        <!-- Quick Filters -->
        <div class="filter-bar">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-box" 
                placeholder="🔍 Search by name, email or roll number..." 
                AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
            
            <asp:DropDownList ID="ddlFilterCollege" runat="server" CssClass="filter-dropdown"
                AutoPostBack="true" OnSelectedIndexChanged="ddlFilterCollege_SelectedIndexChanged">
                <asp:ListItem Value="0">All Colleges</asp:ListItem>
            </asp:DropDownList>

            <asp:Button ID="btnRefresh" runat="server" CssClass="refresh-btn" 
                Text="↻ Refresh" OnClick="btnRefresh_Click" />
        </div>

        <!-- Students List -->
        <div class="students-list">
            <asp:Repeater ID="rptStudents" runat="server" OnItemCommand="rptStudents_ItemCommand">
                <ItemTemplate>
                    <div class="student-item" id="student_<%# Eval("UserID") %>">
                        <div class="student-main">
                            <!-- Student Info -->
                            <div class="student-details">
                                <div class="avatar"><%# GetInitials(Eval("FullName").ToString()) %></div>
                                <div class="info">
                                    <h3 class="name"><%# Eval("FullName") %></h3>
                                    <div class="meta">
                                        <span class="meta-item">📧 <%# Eval("Email") %></span>
                                        <span class="meta-item">📱 <%# Eval("Phone") %></span>
                                        <span class="meta-item">🎓 <%# Eval("RollNumber") %></span>
                                    </div>
                                    <div class="meta">
                                        <span class="meta-item">🏫 <%# Eval("CollegeName") %></span>
                                        <span class="meta-item">📚 <%# Eval("DepartmentName") %></span>
                                        <span class="meta-item">📖 <%# Eval("CourseName") %></span>
                                    </div>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="action-buttons">
                                <asp:HyperLink ID="lnkViewID" runat="server" 
                                    NavigateUrl='<%# Eval("StudentIDProofPath") %>' 
                                    Target="_blank"
                                    CssClass="btn btn-view">
                                    👁️ View ID
                                </asp:HyperLink>

                                <asp:LinkButton ID="btnApprove" runat="server"
                                    CommandName="Approve"
                                    CommandArgument='<%# Eval("UserID") %>'
                                    CssClass="btn btn-approve">
                                    ✓ Approve
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnReject" runat="server"
                                    CommandName="Reject"
                                    CommandArgument='<%# Eval("UserID") %>'
                                    CssClass="btn btn-reject"
                                    OnClientClick="return confirm('Reject this student?');">
                                    ✗ Reject
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <!-- Empty State -->
            <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty-state" Visible="false">
                <div class="empty-icon">🎉</div>
                <h3 class="empty-title">All Caught Up!</h3>
                <p class="empty-text">No pending student verifications at the moment.</p>
            </asp:Panel>
        </div>

        <!-- Pagination -->
        <asp:Panel ID="pnlPagination" runat="server" CssClass="pagination-bar">
            <div class="page-info">
                <asp:Label ID="lblPageInfo" runat="server"></asp:Label>
            </div>
            <div class="page-controls">
                <asp:LinkButton ID="btnFirstPage" runat="server" CssClass="page-btn" OnClick="btnFirstPage_Click">⏮</asp:LinkButton>
                <asp:LinkButton ID="btnPrevPage" runat="server" CssClass="page-btn" OnClick="btnPrevPage_Click">◀</asp:LinkButton>
                <span class="page-numbers">
                    <asp:Literal ID="litCurrentPage" runat="server">1</asp:Literal> / <asp:Literal ID="litTotalPages" runat="server">1</asp:Literal>
                </span>
                <asp:LinkButton ID="btnNextPage" runat="server" CssClass="page-btn" OnClick="btnNextPage_Click">▶</asp:LinkButton>
                <asp:LinkButton ID="btnLastPage" runat="server" CssClass="page-btn" OnClick="btnLastPage_Click">⏭</asp:LinkButton>
            </div>
        </asp:Panel>

        <!-- Quick Stats Footer -->
        <div class="stats-footer">
            <div class="stat-item">
                <span class="stat-icon">⏳</span>
                <span class="stat-value"><asp:Literal ID="litPendingCount2" runat="server">0</asp:Literal></span>
                <span class="stat-label">Pending</span>
            </div>
            <div class="stat-item">
                <span class="stat-icon">✓</span>
                <span class="stat-value"><asp:Literal ID="litVerifiedCount" runat="server">0</asp:Literal></span>
                <span class="stat-label">Verified</span>
            </div>
            <div class="stat-item">
                <span class="stat-icon">✗</span>
                <span class="stat-value"><asp:Literal ID="litRejectedCount" runat="server">0</asp:Literal></span>
                <span class="stat-label">Rejected</span>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // Auto-hide approved student with animation
        function hideStudent(studentId) {
            var element = document.getElementById('student_' + studentId);
            if (element) {
                element.style.opacity = '0';
                element.style.transform = 'translateX(100px)';
                setTimeout(function() {
                    element.style.display = 'none';
                }, 300);
            }
        }

        // Show success message briefly
        function showSuccessMessage(message) {
            var alertBox = document.querySelector('.alert-box');
            if (alertBox) {
                alertBox.style.display = 'flex';
                setTimeout(function() {
                    alertBox.style.opacity = '0';
                    setTimeout(function() {
                        alertBox.style.display = 'none';
                        alertBox.style.opacity = '1';
                    }, 300);
                }, 3000);
            }
        }
    </script>
</asp:Content>