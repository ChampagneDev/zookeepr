"""The application's model objects"""
import sqlalchemy as sa
from sqlalchemy import orm

from zookeepr.model import meta

import person
import role
import person_role_map
import password_reset_confirmation
import proposal
import person_proposal_map
import attachment
import review
import db_content
import volunteer
import voucher
import invoice
import invoice_item
import payment
import ceiling
import product
import product_ceiling_map
import rego_note

from person import Person
from role import Role
from password_reset_confirmation import PasswordResetConfirmation

from proposal import Proposal, ProposalStatus, ProposalType, TravelAssistanceType, AccommodationAssistanceType, TargetAudience
from attachment import Attachment
from review import Review, Stream

from product import Product, ProductInclude
from product_category import ProductCategory
from ceiling import Ceiling

from invoice import Invoice
from invoice_item import InvoiceItem
from payment import Payment

from registration import Registration
from registration_product import RegistrationProduct

from voucher import Voucher, VoucherProduct

from db_content import DbContentType, DbContent

def init_model(engine):
    """Call me before using any of the tables or classes in the model"""
    meta.Session.configure(bind=engine)
    meta.engine = engine

def setup(meta):
    """Setup any data in the tables"""

    role.setup(meta)
    person_role_map.setup(meta)
    person.setup(meta)

    product_category.setup(meta)
    ceiling.setup(meta)
    product.setup(meta)

    proposal.setup(meta)
    person_proposal_map.setup(meta)
    attachment.setup(meta)
    review.setup(meta)
    voucher.setup(meta)

    db_content.setup(meta)
    volunteer.setup(meta)

    meta.Session.commit()

## Non-reflected tables may be defined and mapped at module level
#foo_table = sa.Table("Foo", meta.metadata,
#    sa.Column("id", sa.types.Integer, primary_key=True),
#    sa.Column("bar", sa.types.String(255), nullable=False),
#    )
#
#class Foo(object):
#    pass
#
#orm.mapper(Foo, foo_table)


## Classes for reflected tables may be defined here, but the table and
## mapping itself must be done in the init_model function
#reflected_table = None
#
#class Reflected(object):
#    pass
