export const qKey = (tid, sid, sl) => `${tid}||${sid}||${sl}`;

export const totalQs = (topic) =>
  topic.sections.reduce((acc, s) => acc + s.qs.length, 0);

export const doneQs = (topic, statuses) =>
  topic.sections.reduce(
    (acc, s) =>
      acc + s.qs.filter((q) => statuses[qKey(topic.id, s.id, q[0])] === "Done").length,
    0
  );
