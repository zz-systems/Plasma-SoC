#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/device.h>
#include <linux/platform_device.h>
#include <linux/slab.h>
#include <linux/io.h>
#include <linux/of.h>

#define DRV_NAME "plsoc_counter"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Sergej Zuyev");
MODULE_DESCRIPTION("Plasma-SoC counter control driver");


#define PLSOC_REG_CONTROL	(0x0)
#define PLSOC_REG_STATUS	(0x4)
#define PLSOC_REG_DATA	    (0x8)
#define PLSOC_REG_RELOAD	(0xC)

struct plsoc_counter {
    void __iomem *regs;
};

ssize_t plsoc_counter_show_reload(struct device *dev, struct device_attribute *attr, char *buf)
{
	struct plsoc_counter *counter = dev_get_drvdata(dev);

    return scnprintf(buf, PAGE_SIZE, "%u\n", readl(counter->regs + PLSOC_REG_RELOAD));
}

ssize_t plsoc_counter_store_reload(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
    u32 reload;
	struct plsoc_counter *counter;

	if (buf == NULL) {
		pr_err("Error, string must not be NULL\n");
		return -EINVAL;
	}

	if (kstrtou32(buf, 10, &reload) < 0) {
		pr_err("Could not convert string to integer\n");
		return -EINVAL;
	}

    counter = dev_get_drvdata(dev);

	writel(reload, (counter->regs + PLSOC_REG_RELOAD));

	return count;
}

static DEVICE_ATTR(reload, S_IRUGO | S_IWUSR, plsoc_counter_show_reload, plsoc_counter_store_reload);

static struct attribute *plsoc_counter_attrs[] = {
	&dev_attr_reload.attr,
	NULL,
};

struct attribute_group plsoc_counter_attr_group = {
	.name = "counter",
	.attrs = plsoc_counter_attrs,
};

static int plsoc_counter_probe(struct platform_device *pdev)
{
	struct plsoc_counter *counter;
	struct resource	*regs;

	counter = devm_kzalloc(&pdev->dev, sizeof(struct plsoc_counter), GFP_KERNEL);
	if (!counter)
		return -ENOMEM;

	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	if (!regs)
		return -ENXIO;

	counter->regs = devm_ioremap_resource(&pdev->dev, regs);
	if (IS_ERR(counter->regs))
		return PTR_ERR(counter->regs);

	platform_set_drvdata(pdev, counter);

	return sysfs_create_group(&pdev->dev.kobj, &plsoc_counter_attr_group);
}

static int plsoc_counter_remove(struct platform_device *pdev)
{
	sysfs_remove_group(&pdev->dev.kobj, &plsoc_counter_attr_group);
	platform_set_drvdata(pdev, NULL);

	return 0;
}

static const struct of_device_id plsoc_counter_match[] = {
	{ .compatible = "plsoc,counter" },
	{ /* Sentinel */ }
};

MODULE_DEVICE_TABLE(of, plsoc_counter_match);

static struct platform_driver plsoc_counter_platform_driver = {
	.driver = {
		.name		= DRV_NAME,
		.owner		= THIS_MODULE,
		.of_match_table	= of_match_ptr(plsoc_counter_match),
	},
	.probe 			= plsoc_counter_probe,
	.remove			= plsoc_counter_remove,
};

static int __init plsoc_counter_init(void)
{
	printk(KERN_NOTICE "Plsoc-counter: registering Plasma SoC counter.");
	return platform_driver_register(&plsoc_counter_platform_driver);
}
static void __exit plsoc_counter_exit(void)
{
	platform_driver_unregister(&plsoc_counter_platform_driver);
}

module_init(plsoc_counter_init);
module_exit(plsoc_counter_exit);
