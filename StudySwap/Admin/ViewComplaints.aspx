<%@ Page Title="Complaints" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewComplaints.aspx.cs" Inherits="StudySwap.Admin.ViewComplaints" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Complaints
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .badge { font-size: 0.8rem; padding: 6px 10px; border-radius: 6px; font-weight: 600; }
        .badge-pending    { background: #fff3cd; color: #856404; }
        .badge-inprogress { background: #cff4fc; color: #055160; }
        .badge-completed  { background: #d1e7dd; color: #0f5132; }
        .badge-rejected   { background: #f8d7da; color: #842029; }

        .prio { font-size: 0.8rem; padding: 6px 10px; border-radius: 6px; font-weight: 600; }
        .prio-low     { background: #e2e3e5; color: #41464b; }
        .prio-medium  { background: #cfe2ff; color: #084298; }
        .prio-high    { background: #ffe5b4; color: #8a4b00; }
        .prio-urgent  { background: #f8d7da; color: #842029; }

        .table th { background: #f8f9fa; font-size: 0.9rem; }
        .table td { vertical-align: middle; font-size: 0.9rem; }

        /* Modal styling fallback (in case Bootstrap modal JS isn't wired) */
        .modal-backdrop-custom {
            position: fixed; inset: 0; background: rgba(0,0,0,0.5);
            display: none; z-index: 1040;
        }
        .modal-backdrop-custom.show { display: block; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container-fluid">

        <!-- ================= PAGE HEADER ================= -->
        <div class="row mb-3">
            <div class="col-12">
                <h2 class="text-primary">
                    <i class="fas fa-comment-dots me-2"></i> Manage Complaints
                </h2>
                <p class="text-muted">Review, filter and respond to student complaints.</p>
            </div>
        </div>

        <!-- ================= MESSAGE LABEL ================= -->
        <asp:Label ID="lblMsg" runat="server" CssClass="d-block mb-2" EnableViewState="false"></asp:Label>

        <!-- ================= FILTERS ================= -->
        <div class="card shadow-sm mb-3">
            <div class="card-body">
                <div class="row g-2 align-items-end">

                    <div class="col-md-3">
                        <label class="form-label small mb-1">Search</label>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control form-control-sm"
                            placeholder="Subject, description or student..."></asp:TextBox>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label small mb-1">Status</label>
                        <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-select form-select-sm">
                            <asp:ListItem Text="All"          Value="" />
                            <asp:ListItem Text="Pending"      Value="Pending" />
                            <asp:ListItem Text="In Progress"  Value="In Progress" />
                            <asp:ListItem Text="Completed"    Value="Completed" />
                            <asp:ListItem Text="Rejected"     Value="Rejected" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label small mb-1">Category</label>
                        <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="form-select form-select-sm">
                            <asp:ListItem Text="All"         Value="" />
                            <asp:ListItem Text="General"     Value="General" />
                            <asp:ListItem Text="Technical"   Value="Technical" />
                            <asp:ListItem Text="Listing"     Value="Listing" />
                            <asp:ListItem Text="Payment"     Value="Payment" />
                            <asp:ListItem Text="Account"     Value="Account" />
                            <asp:ListItem Text="Other"       Value="Other" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label small mb-1">Priority</label>
                        <asp:DropDownList ID="ddlPriorityFilter" runat="server" CssClass="form-select form-select-sm">
                            <asp:ListItem Text="All"     Value="" />
                            <asp:ListItem Text="Low"     Value="Low" />
                            <asp:ListItem Text="Medium"  Value="Medium" />
                            <asp:ListItem Text="High"    Value="High" />
                            <asp:ListItem Text="Urgent"  Value="Urgent" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-3 text-end">
                        <asp:Button ID="btnFilter" runat="server" Text="Filter"
                            CssClass="btn btn-primary btn-sm me-1" OnClick="btnFilter_Click" />
                        <asp:Button ID="btnReset" runat="server" Text="Reset"
                            CssClass="btn btn-outline-secondary btn-sm" OnClick="btnReset_Click" />
                    </div>

                </div>
            </div>
        </div>

        <!-- ================= GRIDVIEW ================= -->
        <div class="card shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <asp:GridView ID="gvComplaints" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="table table-hover table-bordered mb-0"
                        GridLines="None"
                        AllowPaging="true"
                        PageSize="10"
                        OnPageIndexChanging="gvComplaints_PageIndexChanging"
                        OnRowCommand="gvComplaints_RowCommand"
                        EmptyDataText="No complaints found.">
                        <PagerStyle CssClass="pagination-wrap p-2" HorizontalAlign="Center" />
                        <Columns>

                            <asp:BoundField DataField="ComplaintID" HeaderText="ID" ItemStyle-Width="50px" />

                            <asp:TemplateField HeaderText="Student">
                                <ItemTemplate>
                                    <div class="fw-semibold"><%# Eval("StudentName") %></div>
                                    <small class="text-muted"><%# Eval("StudentEmail") %></small>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="Category" HeaderText="Category" />
                            <asp:BoundField DataField="Subject"  HeaderText="Subject" />

                            <asp:TemplateField HeaderText="Priority">
                                <ItemTemplate>
                                    <span class='<%# GetPriorityClass(Eval("Priority")) %>'>
                                        <%# Eval("Priority") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='<%# GetStatusBadgeClass(Eval("Status")) %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Created">
                                <ItemTemplate>
                                    <%# Eval("CreatedDate", "{0:dd MMM yyyy}") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Action" ItemStyle-Width="120px">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnUpdate" runat="server"
                                        CssClass="btn btn-sm btn-outline-primary"
                                        CommandName="UpdateStatus"
                                        CommandArgument='<%# Eval("ComplaintID") %>'
                                        CausesValidation="false">
                                        <i class="fas fa-edit"></i> Update
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

    </div>

    <!-- ================= STATUS MODAL (INSIDE FORM) ================= -->
    <div class="modal fade" id="statusModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Update Complaint</h5>
                    <button type="button" class="btn-close btn-close-white"
                            data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">

                    <asp:HiddenField ID="hfComplaintID" runat="server" />

                    <div class="mb-3">
                        <div class="small text-muted">Complaint #<asp:Literal ID="litInfoId" runat="server" /></div>
                        <div class="fw-semibold"><asp:Literal ID="litInfoSubject" runat="server" /></div>
                        <div class="small">From: <asp:Literal ID="litInfoStudent" runat="server" /></div>
                        <div class="small">Category: <asp:Literal ID="litInfoCategory" runat="server" /></div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <div class="border rounded p-2 bg-light small" style="max-height:150px; overflow:auto;">
                            <asp:Literal ID="litInfoDesc" runat="server" />
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">New Status</label>
                            <asp:DropDownList ID="ddlNewStatus" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Pending"     Value="Pending" />
                                <asp:ListItem Text="In Progress" Value="In Progress" />
                                <asp:ListItem Text="Completed"   Value="Completed" />
                                <asp:ListItem Text="Rejected"    Value="Rejected" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label fw-semibold">Admin Response</label>
                            <asp:TextBox ID="txtAdminResponse" runat="server"
                                CssClass="form-control" TextMode="MultiLine" Rows="3"
                                placeholder="Write your response to the student..."></asp:TextBox>
                        </div>
                    </div>

                </div>

                <div class="modal-footer">
                    <asp:Button ID="btnCancelStatus" runat="server" Text="Cancel"
                        CssClass="btn btn-secondary"
                        OnClick="btnCancelStatus_Click" CausesValidation="false" />
                    <asp:Button ID="btnSaveStatus" runat="server" Text="Save Changes"
                        CssClass="btn btn-primary"
                        OnClick="btnSaveStatus_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- ================= MODAL HELPERS ================= -->
    <script>
        function openStatusModal() {
            var modalEl = document.getElementById('statusModal');
            var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
        }
        function closeStatusModal() {
            var modalEl = document.getElementById('statusModal');
            var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.hide();
        }
    </script>

</asp:Content>