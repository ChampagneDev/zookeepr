    <div class="notice-box">
% if c.ceilings['conference'].available():
      <b>Registrations</b> are open<br><br>
% else:
      <b>Registrations are closed</b><br><br>
% #endif
      <div class = "graph-bar" style = "width:<% h.number_to_percentage(c.ceilings['conference'].percent_invoiced(), precision=0) %>">&nbsp;</div>
      <div class = "graph-bar-text"><% h.ticket_percentage_text(c.ceilings['conference'].percent_invoiced()) %></div><br>
% if c.ceilings['earlybird'].available():
      <b>Earlybird</b> is available<br><br>
      <div class = "graph-bar" style = "width:<% h.number_to_percentage(c.ceilings['earlybird'].percent_invoiced(), precision=0) %>">&nbsp;</div>
      <div class = "graph-bar-text"><% h.ticket_percentage_text(c.ceilings['earlybird'].percent_invoiced(), True) |h%></div><br>
% else:
      <b>Earlybird no longer available</b><br><br><% c.ebtext |h%>
% #endif
      <b><%c.timeleft %></b>
    </div>
% if not c.ceilings['conference'].available():
    <h2>Registrations are closed</h2>
    <p>Registrations are now closed. You will only be able to register if you
    have an existing voucher code or if you're otherwise entitled to attend
    for free (eg speakers).</p>
% #endif
    <h3>Your registration status</h3>

% if not c.signed_in_person:
    <p><b>Not signed in.</b></p>

    <h3>Next step</h3>

    <p><% h.link_to('Sign in', h.url(controller='person', action='signin')) %> if you already have an account
    (you've already registered, submitted a proposal or similar).  If you can't log in, you can try
    <% h.link_to('recovering your password', h.url(controller='person', action='forgotten_password')) %>.</p>
%   session['sign_in_redirect'] = '/registration/status'
%   session.save()

    <p><% h.link_to('Go directly to the registration form', h.url(action='new')) %> otherwise.</p>

% elif c.signed_in_person and c.signed_in_person.registration == None:
    <p><b>Not registered.</b>

    <h3>Next step</h3>

    <p><% h.link_to('Fill in registration form', h.url(action='new')) %>.</p>

% elif c.signed_in_person and c.signed_in_person.registration:
    <p><b>Tentatively registered.</b></p>

    <h3>Next step</h3>

%   if False and not c.signed_in_person.registration.volunteer:
    <p><% h.link_to('Select areas of interest and ability', h.url(action='volunteer', id=c.signed_in_person.registration.id)) %></p>
%   else:
%       if c.signed_in_person.valid_invoice():
    <p><% h.link_to('View Invoice', h.url(action='pay', id=c.signed_in_person.registration.id)) %></p>
%       else:
    <p><% h.link_to('Generate Invoice', h.url(action='pay', id=c.signed_in_person.registration.id)) %></p>
%       #endif
%   #endif

    <h3>Other option</h3>

    <p>
%   if False and c.signed_in_person.registration.type=='Volunteer':
    <% h.link_to('Change areas of interest and ability', h.url(action='volunteer', id=c.signed_in_person.registration.id)) %><br>
%   #endif
    <% h.link_to('Edit details', h.url(action='edit', id=c.signed_in_person.registration.id)) %><br>
    <% h.link_to('Regenerate invoice', h.url(action='pay', id=c.signed_in_person.registration.id)) %><br>
    <% h.link_to('View details', h.url(action='view', id=c.signed_in_person.registration.id)) %><br>
    <table>
      <tr>
        <th>Invoice #</th>
        <th>Status</th>
        <th>Amount</th>
        <th></th>
      </tr>
%   for invoice in c.signed_in_person.invoices:
      <tr>
        <td><% invoice.id %></td>
        <td><% invoice.status() %></td>
        <td><% h.number_to_currency(invoice.total() / 100) %></td>
        <td>
          <% h.link_to('View', h.url(action='view', id=invoice.id)) %>
          <% h.link_to('Printable (html)', h.url(action='printable', id=invoice.id)) %>
          <% h.link_to('Get Printable (pdf)', h.url(action='pdf', id=invoice.id)) %>
        </td>
      </tr>
%   #endfor
    </table>

% elif False and c.signed_in_person.invoices[0].bad_payments:
    <p><b>Tentatively registered and tried to pay.</b></p>

    <p>Unfortunately, there was some sort of problem with your payment.</p>

    <h3>Next step</h3>

    <p><% h.contact_email('Contact the committee') %></p>

    <p>Your details are:
    person <% c.signed_in_person.id %>,
    registration <% c.signed_in_person.registration.id %>,
    invoice <% c.signed_in_person.invoices[0].id %>.</p>

    <h3>Other option</h3>
    <a href="/registration/<% c.signed_in_person.registration.id %>">View registration details</a><br>

% else:
    <p>Interesting!</p>
% #endif

    <h3>Summary of steps</h3>
% if c.signed_in_person:
    <p><% h.yesno(c.signed_in_person.registration != None) %> Fill in registration form
    <br><% h.yesno(c.signed_in_person.valid_invoice()) %> Generate invoice
    <br><% h.yesno(c.able_to_edit()) %> Pay
    <br><% h.yesno(False) %> Attend conference</p>
% else:
    <p><% h.yesno(False) %> Fill in registration form
    <br><% h.yesno(False) %> Generate invoice
    <br><% h.yesno(False) %> Pay
    <br><% h.yesno(False) %> Attend conference</p>
% #endif
