trigger Product2 on Product2 (before insert, before update)
{
    if (trigger.isBefore)
    {
        if (trigger.isInsert)
        {
            ProductService.findProductManager(trigger.new);
        }
        if (trigger.isUpdate)
        {
            ProductService.findProductManager(trigger.new);
        }
    }
}